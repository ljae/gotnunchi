import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:gotnunchi/core/constants/region_data.dart';

/// Interactive map widget displaying districts for a specific region
///
/// Loads GeoJSON data and renders district boundaries
/// Supports tap interaction for district selection
class DistrictMapWidget extends StatefulWidget {
  /// The parent region ID (e.g., KR-11, KR-41)
  final String parentRegionId;

  /// Path to the GeoJSON file for this region
  final String geoJsonPath;

  /// Initial center coordinate for the map
  final LatLng initialCenter;

  /// Initial zoom level
  final double initialZoom;

  /// Callback when a district is tapped
  final Function(String districtId) onDistrictTap;

  /// Currently selected district IDs (Multi-select)
  final Set<String> selectedDistrictIds;

  const DistrictMapWidget({
    super.key,
    required this.parentRegionId,
    required this.geoJsonPath,
    required this.initialCenter,
    required this.initialZoom,
    required this.onDistrictTap,
    this.selectedDistrictIds = const {},
  });

  @override
  State<DistrictMapWidget> createState() => _DistrictMapWidgetState();
}

class _DistrictPolygon {
  final String districtId;
  final String districtName;
  final List<LatLng> points;

  _DistrictPolygon({
    required this.districtId,
    required this.districtName,
    required this.points,
  });
}

class _DistrictMapWidgetState extends State<DistrictMapWidget> {
  final List<_DistrictPolygon> _districtPolygons = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    try {
      // Load GeoJSON from assets
      final String geoJsonString = await rootBundle.loadString(widget.geoJsonPath);

      // Parse GeoJSON
      final Map<String, dynamic> geoJson = json.decode(geoJsonString);
      final List<dynamic> features = geoJson['features'] ?? [];

      // Get correct map for name conversion
      final nameToIdMap = RegionData.getNameToIdMap(widget.parentRegionId);

      // Convert features to polygon data
      for (var feature in features) {
        final props = feature['properties'] as Map<String, dynamic>?;
        final geometry = feature['geometry'] as Map<String, dynamic>?;

        if (props != null && geometry != null) {
          // GeoJSON properties usually have 'name' or similar for the Korean name
          // The Gyeonggi file format needs to be checked, but usually 'ADM_DR_NM' or 'name'
          // We'll try common keys
          String? koreanName = props['name'] ?? props['ADM_DR_NM'] ?? props['sid_nm']; 
          
          if (koreanName != null) {
             // Handle some potential whitespace or format issues
             koreanName = koreanName.trim();
          }

          final String? districtId = koreanName != null ? nameToIdMap[koreanName] : null;

          if (districtId != null && geometry['type'] == 'Polygon') {
            final coordinates = geometry['coordinates'] as List<dynamic>;

            if (coordinates.isNotEmpty) {
              final outerRing = coordinates[0] as List<dynamic>;
              final points = outerRing.map((coord) {
                final c = coord as List<dynamic>;
                // GeoJSON is [lon, lat]
                return LatLng(c[1] as double, c[0] as double);
              }).toList();

              _districtPolygons.add(_DistrictPolygon(
                districtId: districtId,
                districtName: RegionData.getDistrictName(districtId) ?? koreanName!,
                points: points,
              ));
            }
          // Handle MultiPolygon if necessary (Gyeonggi might have some)
          } else if (districtId != null && geometry['type'] == 'MultiPolygon') {
              final coordinateGroups = geometry['coordinates'] as List<dynamic>;
              for (var group in coordinateGroups) {
                 if (group.isNotEmpty) {
                    final outerRing = group[0] as List<dynamic>;
                    final points = outerRing.map((coord) {
                      final c = coord as List<dynamic>;
                      return LatLng(c[1] as double, c[0] as double);
                    }).toList();
                    
                     _districtPolygons.add(_DistrictPolygon(
                      districtId: districtId,
                      districtName: RegionData.getDistrictName(districtId) ?? koreanName!,
                      points: points,
                    ));
                 }
              }
          }
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getPolygonColor(String districtId) {
    if (widget.selectedDistrictIds.contains(districtId)) {
      return const Color(0xFF3B82F6); // Blue 500 - selected
    }
    return Colors.grey.shade300; // Default
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading map data...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load map data'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _error!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    // Create markers for labels
    // We might have multiple polygons for one district (MultiPolygon), so we deduplicate labels
    final shownLabels = <String>{};
    final markers = <Marker>[];

    for (var polygon in _districtPolygons) {
       if (!shownLabels.contains(polygon.districtId)) {
          shownLabels.add(polygon.districtId);
          markers.add(Marker(
            point: _calculateCentroid(polygon.points),
            width: 80,
            height: 30,
            child: IgnorePointer(
              child: Center(
                child: Text(
                  polygon.districtName,
                  style: TextStyle(
                    color: widget.selectedDistrictIds.contains(polygon.districtId)
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ));
       }
    }


    return FlutterMap(
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        minZoom: widget.initialZoom - 1.0,
        maxZoom: widget.initialZoom + 3.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onTap: (tapPosition, latLng) {
          _handleMapTap(latLng);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.gotnunchi.app',
        ),
        if (_districtPolygons.isNotEmpty)
          PolygonLayer(
            polygons: _districtPolygons.map((districtPolygon) {
              return Polygon(
                points: districtPolygon.points,
                color: _getPolygonColor(districtPolygon.districtId).withValues(alpha: 0.7),
                borderColor: Colors.white,
                borderStrokeWidth: 2.0,
                isFilled: true,
                isDotted: false,
              );
            }).toList(),
          ),
        
        if (markers.isNotEmpty)
          MarkerLayer(markers: markers),
      ],
    );
  }

  LatLng _calculateCentroid(List<LatLng> points) {
    double latSum = 0;
    double lngSum = 0;
    for (var point in points) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }

  void _handleMapTap(LatLng latLng) {
    for (var districtPolygon in _districtPolygons) {
      if (_isPointInPolygon(latLng, districtPolygon.points)) {
        widget.onDistrictTap(districtPolygon.districtId);
        return;
      }
    }
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; j = i++) {
      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;
      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;

      final intersect = ((yi > point.latitude) != (yj > point.latitude)) &&
          (point.longitude <
              (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);

      if (intersect) inside = !inside;
    }

    return inside;
  }
}
