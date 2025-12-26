import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gotnunchi/core/widgets/app_logo_widget.dart';
import 'package:gotnunchi/core/constants/region_data.dart';
import 'package:gotnunchi/features/region_map/presentation/widgets/district_map_widget.dart';
import 'package:gotnunchi/features/community/presentation/screens/board_list_screen.dart';
import 'package:latlong2/latlong.dart';

/// Screen for selecting districts within a region (Seoul, Gyeonggi, etc.)
class RegionDetailMapScreen extends StatefulWidget {
  final String regionId;

  const RegionDetailMapScreen({super.key, required this.regionId});

  @override
  State<RegionDetailMapScreen> createState() => _RegionDetailMapScreenState();
}

class _RegionDetailMapScreenState extends State<RegionDetailMapScreen> {
  final Set<String> _selectedDistrictIds = {};

  void _handleDistrictTap(String districtId) {
    setState(() {
      if (_selectedDistrictIds.contains(districtId)) {
        _selectedDistrictIds.remove(districtId);
      } else {
        _selectedDistrictIds.add(districtId);
      }
    });
  }

  void _handleAllRegionTap() {
    setState(() {
      _selectedDistrictIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine map configuration based on regionId
    String geoJsonPath;
    LatLng center;
    double zoom;
    String regionName;

    if (widget.regionId == RegionData.seoulId) {
      geoJsonPath = 'lib/features/region_map/data/seoul_districts.geojson';
      center = const LatLng(37.5665, 126.9780);
      zoom = 10.5;
      regionName = 'Seoul';
    } else if (widget.regionId == RegionData.gyeonggiId) {
      geoJsonPath = 'lib/features/region_map/data/gyeonggi_districts.geojson';
      center = const LatLng(37.4138, 127.5183); // Approx center of Gyeonggi
      zoom = 9.0;
      regionName = 'Gyeonggi-do';
    } else {
      // Fallback or error
      return const Scaffold(body: Center(child: Text('Region map not found')));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100.0,
        title: const AppLogoWidget(height: 60),
      ),
      body: Stack(
        children: [
          // Background - Map
          // Use SizedBox/Container to ensure it takes space, or Positioned.fill
          Positioned.fill(
            child: DistrictMapWidget(
                  parentRegionId: widget.regionId,
                  geoJsonPath: geoJsonPath,
                  initialCenter: center,
                  initialZoom: zoom,
                  onDistrictTap: _handleDistrictTap,
                  selectedDistrictIds: _selectedDistrictIds,
            ),
          ),
          
          // Map controls overlaid on top of map but behind sheet
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton.small(
              onPressed: _handleAllRegionTap,
              tooltip: 'Clear Selection',
              child: const Icon(Icons.refresh),
            ),
          ),
          
           Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
                ),
                child: Text(
                  _selectedDistrictIds.isEmpty 
                      ? 'Select districts' 
                      : '${_selectedDistrictIds.length} districts selected',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),

          // Draggable Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.15,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    
                    // Header / Empty State
                     Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _selectedDistrictIds.isEmpty 
                           ? 'Select districts on the map'
                           : 'Showing posts from ${_selectedDistrictIds.length} districts',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ),

                    const Divider(height: 1),

                    // Content
                    Expanded(
                      child: _selectedDistrictIds.isEmpty
                          ? Center(
                              child: Text(
                                'No districts selected',
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            )
                          // We need to pass the ScrollController to the ListView inside BoardListWidget
                          // BUT BoardListWidget currently manages its own ListView.
                          // To make DraggableScrollableSheet work nicely, the internal ListView needs this controller.
                          // Short term fix: Wrap BoardListWidget content or modify it?
                          // Let's modify BoardListWidget to accept a ScrollController?
                          // OR, we can just use SingleChildScrollView here? No, list virtualization is better.
                          // IMPORTANT: DraggableScrollableSheet needs the scrolling child to have the controller.
                          // I will update BoardListWidget to accept an optional ScrollController.
                          : BoardListWidget(
                                regionIds: _selectedDistrictIds.toList(),
                                scrollController: scrollController,
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
