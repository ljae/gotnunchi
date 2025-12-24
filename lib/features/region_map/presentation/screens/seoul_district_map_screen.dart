import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gotnunchi/core/widgets/app_logo_widget.dart';
import 'package:gotnunchi/core/constants/seoul_districts.dart';
import 'package:gotnunchi/features/region_map/presentation/widgets/seoul_map_widget.dart';

/// Screen for selecting Seoul districts
///
/// Displays an interactive map of Seoul's 25 districts
/// Users can tap a district to view its community board
class SeoulDistrictMapScreen extends StatefulWidget {
  const SeoulDistrictMapScreen({super.key});

  @override
  State<SeoulDistrictMapScreen> createState() => _SeoulDistrictMapScreenState();
}

class _SeoulDistrictMapScreenState extends State<SeoulDistrictMapScreen> {
  String? _selectedDistrictId;

  void _handleDistrictTap(String districtId) {
    setState(() {
      _selectedDistrictId = districtId;
    });

    // Navigate to board after brief delay to show selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.go('/board/$districtId');
    });
  }

  void _handleAllSeoulTap() {
    context.go('/board/${SeoulDistricts.allSeoulId}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 110.0,
        title: const AppLogoWidget(height: 92),
      ),
      body: Column(
        children: [
          // "All of Seoul" button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _handleAllSeoulTap,
              icon: const Icon(Icons.location_city),
              label: const Text('All of Seoul'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.map,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Your District',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Seoul map
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: SeoulMapWidget(
                  onDistrictTap: _handleDistrictTap,
                  selectedDistrictId: _selectedDistrictId,
                ),
              ),
            ),
          ),

          // Helper text
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tap on a district to view community',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
