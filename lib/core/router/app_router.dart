import 'package:debloat/core/widgets/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your screens
import '../../features/daily_regimen/presentation/screens/dashboard_screen.dart';
import '../../features/daily_regimen/presentation/screens/workout_session_screen.dart';
// import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
// import '../../features/progress/presentation/screens/progress_screen.dart';

// 1. DEFINE KEYS OUTSIDE THE PROVIDER
// This ensures they don't get recreated on hot reload/rebuilds
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/today',

    // 2. ADD A REDIRECT LOGIC
    // This catches the app if it tries to load "/" and forces it to "/today"
    redirect: (context, state) {
      if (state.uri.toString() == '/') {
        return '/today';
      }
      return null;
    },

    routes: [
      // 1. THE TABS (Shell)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Today/Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Tab 1: Nutrition
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/nutrition',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text("Nutrition Placeholder")),
                ),
              ),
            ],
          ),
          // Tab 2: Progress
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text("Progress Placeholder")),
                ),
              ),
            ],
          ),
        ],
      ),

      // 2. FULL SCREEN ROUTES (Outside the Shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey, // Covers the bottom nav
        path: '/workout',
        builder: (context, state) => const WorkoutSessionScreen(),
      ),
    ],
  );
});
