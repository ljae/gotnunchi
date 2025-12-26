import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/providers/selected_regions_provider.dart';
import '../../../../core/constants/region_data.dart';
import '../widgets/district_map_widget.dart';

class RegionSelectorScreen extends ConsumerStatefulWidget {
  const RegionSelectorScreen({super.key});

  @override
  ConsumerState<RegionSelectorScreen> createState() =>
      _RegionSelectorScreenState();
}

class _RegionSelectorScreenState extends ConsumerState<RegionSelectorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedRegions = ref.watch(selectedRegionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Regions'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Seoul'),
            Tab(text: 'Gyeonggi'),
          ],
        ),
        actions: [
          if (selectedRegions.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Chip(
                  label: Text('${selectedRegions.length} selected'),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDistrictMap('KR-11'), // Seoul
          _buildDistrictMap('KR-41'), // Gyeonggi
        ],
      ),
    );
  }

  Widget _buildDistrictMap(String parentRegionId) {
    final selectedRegions = ref.watch(selectedRegionsProvider);

    // Seoul configuration
    if (parentRegionId == 'KR-11') {
      return DistrictMapWidget(
        parentRegionId: parentRegionId,
        geoJsonPath: 'lib/features/region_map/data/seoul_districts.geojson',
        initialCenter: const LatLng(37.5665, 126.9780),
        initialZoom: 10.5,
        selectedDistrictIds: selectedRegions,
        onDistrictTap: (districtId) {
          ref.read(selectedRegionsProvider.notifier).toggleRegion(districtId);
        },
      );
    }

    // Gyeonggi configuration
    return DistrictMapWidget(
      parentRegionId: parentRegionId,
      geoJsonPath: 'lib/features/region_map/data/gyeonggi_districts.geojson',
      initialCenter: const LatLng(37.4138, 127.5183),
      initialZoom: 9.0,
      selectedDistrictIds: selectedRegions,
      onDistrictTap: (districtId) {
        ref.read(selectedRegionsProvider.notifier).toggleRegion(districtId);
      },
    );
  }
}
