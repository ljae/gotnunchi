import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable logo widget for AppBar
///
/// Displays the app logo with appropriate sizing for AppBar
/// and includes tap navigation to home screen
class AppLogoWidget extends StatelessWidget {
  /// Height of the logo (default: 36)
  final double height;

  /// Whether to enable home navigation on tap (default: true)
  final bool enableHomeNavigation;

  const AppLogoWidget({
    super.key,
    this.height = 92,
    this.enableHomeNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/gotnunchi_logo.png',
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'GN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          "Don't just live in Korea, have Nunchi.",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary, // Use primary color (Olive)
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );

    if (!enableHomeNavigation) {
      return content;
    }

    return GestureDetector(
      onTap: () {
        if (GoRouterState.of(context).uri.path != '/') {
          context.go('/');
        }
      },
      child: content,
    );
  }
}
