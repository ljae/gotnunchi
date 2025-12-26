import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/providers/selected_regions_provider.dart';
import '../../../../core/constants/region_data.dart';
import '../../../../core/theme/app_theme.dart';
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
      backgroundColor: AppTheme.lightCream,
      body: SafeArea(
        child: Column(
          children: [
            // Beautiful header with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryTeal,
                    AppTheme.darkTeal,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryTeal.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      children: [
                        // Logo (2x bigger)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/gotnunchi_logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Regions',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Choose your districts',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Selected count badge
                        if (selectedRegions.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGold,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentGold.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${selectedRegions.length} selected',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Modern Tab Bar
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorPadding: const EdgeInsets.all(4),
                      dividerColor: Colors.transparent,
                      labelColor: AppTheme.primaryTeal,
                      unselectedLabelColor: Colors.white,
                      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      tabs: const [
                        Tab(
                          height: 46,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_city_rounded, size: 20),
                              SizedBox(width: 8),
                              Text('Seoul'),
                            ],
                          ),
                        ),
                        Tab(
                          height: 46,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.landscape_rounded, size: 20),
                              SizedBox(width: 8),
                              Text('Gyeonggi'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDistrictMap('KR-11'), // Seoul
                  _buildDistrictMap('KR-41'), // Gyeonggi
                ],
              ),
            ),
          ],
        ),
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
