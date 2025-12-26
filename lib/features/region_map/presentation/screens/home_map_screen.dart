import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gotnunchi/core/widgets/app_logo_widget.dart';
import 'package:gotnunchi/core/constants/region_data.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  String? _selectedRegionId;
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    // Initial zoom to enlarge the map
    _transformationController.value = Matrix4.identity()..scale(1.3);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // Define the regions you want to support or highlight.
  // For Korea, IDs are typically 'kr-11' etc. from the instructions.
  // We can pass an empty map initially, and only color the selected one.

  void _navigateAfterDelay(String regionId) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      // Check if region has a sub-map (Seoul, Gyeonggi)
      if (RegionData.hasSubMap(regionId)) {
        context.go('/region-map/$regionId');
      } else {
        context.go('/board/$regionId');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 140.0, // Increased height for logo + slogan
        title: const AppLogoWidget(height: 92), // Larger logo
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push('/chat'),
            tooltip: 'Ephemeral Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Expanded Map Area
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformationController,
              maxScale: 75.0,
              minScale: 0.1,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 0.9, // Square-ish ratio to match Korea map bounds (islands included)
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(-40, 0), // Shift map left to center visually
                        child: SimpleMap(
                          instructions: SMapSouthKorea.instructions,
                          
                          // Professional Map Styling
                          defaultColor: const Color(0xFFE2E8F0), // Slate 200 - Clean, neutral base
                          countryBorder: const CountryBorder(color: Colors.white, width: 1.0), // Added white borders
                          
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
                      // Manual overlaid labels for English region names
                      // Positions are approximate based on relative alignment or absolute offsets could be tricky.
                      // Since SimpleMap scales, using Align with precise offsets is safer for a fixed aspect ratio map.
                      // However, InteractiveViewer scales the child, so we put the labels INSIDE the InteractiveViewer child stack.
                      // Note: SimpleMap is an CustomPaint/SizedBox usually. We need to ensure Stack fits it.
                      
                      // Seoul - Shifted Left
                      const _MapLabel(id: 'KR-11', name: 'Seoul', alignment: Alignment(-0.45, -0.75)),
                      // Gyeonggi
                      const _MapLabel(id: 'KR-41', name: 'Gyeonggi', alignment: Alignment(-0.45, -0.65)),
                      // Incheon
                      const _MapLabel(id: 'KR-28', name: 'Incheon', alignment: Alignment(-0.75, -0.65)),
                      // Gangwon
                      const _MapLabel(id: 'KR-42', name: 'Gangwon', alignment: Alignment(0.1, -0.6)),
                      // Chungbuk
                      const _MapLabel(id: 'KR-43', name: 'Chungbuk', alignment: Alignment(-0.2, -0.25)),
                      // Chungnam
                      const _MapLabel(id: 'KR-44', name: 'Chungnam', alignment: Alignment(-0.75, -0.25)),
                      // Daejeon
                      const _MapLabel(id: 'KR-30', name: 'Daejeon', alignment: Alignment(-0.5, -0.15)),
                      // Sejong - skip overlapping or small
                      // Jeonbuk
                      const _MapLabel(id: 'KR-45', name: 'Jeonbuk', alignment: Alignment(-0.6, 0.1)),
                      // Jeonnam
                      const _MapLabel(id: 'KR-46', name: 'Jeonnam', alignment: Alignment(-0.65, 0.45)),
                      // Gwangju
                      const _MapLabel(id: 'KR-29', name: 'Gwangju', alignment: Alignment(-0.65, 0.3)),
                      // Gyeongbuk
                      const _MapLabel(id: 'KR-47', name: 'Gyeongbuk', alignment: Alignment(0.2, -0.05)),
                      // Daegu
                      const _MapLabel(id: 'KR-27', name: 'Daegu', alignment: Alignment(0.15, 0.1)),
                      // Ulsan
                      const _MapLabel(id: 'KR-31', name: 'Ulsan', alignment: Alignment(0.5, 0.18)),
                      // Gyeongnam
                      const _MapLabel(id: 'KR-48', name: 'Gyeongnam', alignment: Alignment(0.0, 0.35)),
                      // Busan
                      const _MapLabel(id: 'KR-26', name: 'Busan', alignment: Alignment(0.4, 0.35)),
                      // Jeju
                      const _MapLabel(id: 'KR-49', name: 'Jeju', alignment: Alignment(-0.6, 0.9)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0), // Reduced vertical padding
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

class _MapLabel extends StatelessWidget {
  final String id;
  final String name;
  final Alignment alignment;

  const _MapLabel({
    required this.id,
    required this.name,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
          ),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
