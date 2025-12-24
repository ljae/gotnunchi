import 'package:flutter/material.dart';
import 'package:gotnunchi/core/router/app_router.dart';
import 'package:gotnunchi/core/theme/app_theme.dart';
import 'package:gotnunchi/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: GotNunchiApp(),
    ),
  );
}

class GotNunchiApp extends StatelessWidget {
  const GotNunchiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
