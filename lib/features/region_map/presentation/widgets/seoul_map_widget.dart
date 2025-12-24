import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Interactive map widget displaying Seoul's 25 districts
///
/// Loads GeoJSON data and renders district boundaries
/// Supports tap interaction for district selection
class SeoulMapWidget extends StatefulWidget {
  /// Callback when a district is tapped
  final Function(String districtId) onDistrictTap;

  /// Currently selected district ID
  final String? selectedDistrictId;

  const SeoulMapWidget({
    super.key,
    required this.onDistrictTap,
    this.selectedDistrictId,
  });

  @override
  State<SeoulMapWidget> createState() => _SeoulMapWidgetState();
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

class _SeoulMapWidgetState extends State<SeoulMapWidget> {
  final List<_DistrictPolygon> _districtPolygons = [];
  bool _isLoading = true;
  String? _error;

  // Seoul center coordinates
  static const LatLng _seoulCenter = LatLng(37.5665, 126.9780);

  // Map from Korean district names to our ID format
  final Map<String, String> _nameToId = {
    '강남구': 'KR-11-gangnam',
    '강동구': 'KR-11-gangdong',
    '강북구': 'KR-11-gangbuk',
    '강서구': 'KR-11-gangseo',
    '관악구': 'KR-11-gwanak',
    '광진구': 'KR-11-gwangjin',
    '구로구': 'KR-11-guro',
    '금천구': 'KR-11-geumcheon',
    '노원구': 'KR-11-nowon',
    '도봉구': 'KR-11-dobong',
    '동대문구': 'KR-11-dongdaemun',
    '동작구': 'KR-11-dongjak',
    '마포구': 'KR-11-mapo',
    '서대문구': 'KR-11-seodaemun',
    '서초구': 'KR-11-seocho',
    '성동구': 'KR-11-seongdong',
    '성북구': 'KR-11-seongbuk',
    '송파구': 'KR-11-songpa',
    '양천구': 'KR-11-yangcheon',
    '영등포구': 'KR-11-yeongdeungpo',
    '용산구': 'KR-11-yongsan',
    '은평구': 'KR-11-eunpyeong',
    '종로구': 'KR-11-jongno',
    '중구': 'KR-11-jung',
    '중랑구': 'KR-11-jungnang',
  };

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    try {
      // Load GeoJSON from assets
      final String geoJsonString = await rootBundle
          .loadString('lib/features/region_map/data/seoul_districts.geojson');

      // Parse GeoJSON
      final Map<String, dynamic> geoJson = json.decode(geoJsonString);
      final List<dynamic> features = geoJson['features'] ?? [];

      // Convert features to polygon data
      for (var feature in features) {
        final props = feature['properties'] as Map<String, dynamic>?;
        final geometry = feature['geometry'] as Map<String, dynamic>?;

        if (props != null && geometry != null) {
          final String? koreanName = props['name'] as String?;
          final String? districtId = koreanName != null ? _nameToId[koreanName] : null;

          if (districtId != null && geometry['type'] == 'Polygon') {
            final coordinates = geometry['coordinates'] as List<dynamic>;

            // First array is outer boundary (we skip holes for simplicity)
            if (coordinates.isNotEmpty) {
              final outerRing = coordinates[0] as List<dynamic>;
              final points = outerRing.map((coord) {
                final c = coord as List<dynamic>;
                return LatLng(c[1] as double, c[0] as double);
              }).toList();

              _districtPolygons.add(_DistrictPolygon(
                districtId: districtId,
                districtName: koreanName!,
                points: points,
              ));
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
    if (districtId == widget.selectedDistrictId) {
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
            Text('Loading Seoul districts...'),
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

    return FlutterMap(
      options: MapOptions(
        initialCenter: _seoulCenter,
        initialZoom: 10.5,
        minZoom: 10.0,
        maxZoom: 13.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onTap: (tapPosition, latLng) {
          // Handle tap on map polygons
          _handleMapTap(latLng);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.gotnunchi.app',
        ),
        // Render polygons from GeoJSON
        if (_districtPolygons.isNotEmpty)
          PolygonLayer(
            polygons: _districtPolygons.map((districtPolygon) {
              return Polygon(
                points: districtPolygon.points,
                color: _getPolygonColor(districtPolygon.districtId).withValues(alpha: 0.6),
                borderColor: Colors.white,
                borderStrokeWidth: 2.0,
                isFilled: true,
              );
            }).toList(),
          ),
      ],
    );
  }

  void _handleMapTap(LatLng latLng) {
    // Find which polygon was tapped
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
