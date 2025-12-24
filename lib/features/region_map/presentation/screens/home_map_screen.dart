import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gotnunchi/core/widgets/app_logo_widget.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  String? _selectedRegionId;

  // Define the regions you want to support or highlight.
  // For Korea, IDs are typically 'kr-11' etc. from the instructions.
  // We can pass an empty map initially, and only color the selected one.

  void _navigateAfterDelay(String regionId) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      // If Seoul is selected, navigate to district screen
      final route = regionId == 'KR-11' ? '/seoul-districts' : '/board/$regionId';
      context.go(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 110.0, // Increased height for larger logo
        title: const AppLogoWidget(height: 92), // Larger logo
      ),
      body: Column(
        children: [
          // Title section with improved spacing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                Text(
                  'Select a Region',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A), // Slate 900
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your area to find local communities',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Expanded(
            child: InteractiveViewer(
              maxScale: 75.0,
              minScale: 0.1,
              child: SimpleMap(
                instructions: SMapSouthKorea.instructions,
                
                // Professional Map Styling
                defaultColor: const Color(0xFFE2E8F0), // Slate 200 - Clean, neutral base
                
                // Highlight the selected region
                colors: _selectedRegionId != null 
                    ? { 
                        _selectedRegionId!: const Color(0xFF3B82F6) // Blue 500 - Professional accent
                      } 
                    : {},

                callback: (id, name, tapDetails) {
                  setState(() {
                    _selectedRegionId = id;
                  });

                  // Small delay to show the highlight, then navigate
                  _navigateAfterDelay(id);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tap Seoul for district-level communities',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
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
