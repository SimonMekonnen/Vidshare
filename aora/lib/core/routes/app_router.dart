import 'package:aora/features/auth/presentation/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_state/auth_state_bloc.dart';
import '../../features/auth/presentation/screens/login_page.dart';

import '../../features/video_hub/presentation/screens/home_page.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  final AuthStateBloc authStateBloc;

  AppRouter(this.authStateBloc);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authStateBloc.stream),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authStateBloc.state is Authenticated;
      final isAuthRoutes =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isAuthenticated && !isAuthRoutes) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoutes) {
        return '/';
      }

      return null;
    },
  );
}
