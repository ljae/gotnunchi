import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/region_map/presentation/screens/home_map_screen.dart';
import '../../features/region_map/presentation/screens/region_detail_map_screen.dart';
import '../../features/community/presentation/screens/board_list_screen.dart';
import '../../features/community/presentation/screens/post_detail_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeMapScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'region-map/:regionId',
          builder: (BuildContext context, GoRouterState state) {
            final regionId = state.pathParameters['regionId']!;
            return RegionDetailMapScreen(regionId: regionId);
          },
        ),
        GoRoute(
          path: 'board/:regionId',
          builder: (BuildContext context, GoRouterState state) {
            final regionId = state.pathParameters['regionId']!;
            return BoardListScreen(regionId: regionId);
          },
        ),
        GoRoute(
          path: 'post/:postId',
          builder: (BuildContext context, GoRouterState state) {
            final postId = state.pathParameters['postId']!;
            return PostDetailScreen(postId: postId);
          },
        ),
        GoRoute(
          path: 'chat',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
      ],
    ),
  ],
);
