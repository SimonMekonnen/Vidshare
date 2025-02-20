import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_state/auth_state_bloc.dart';
import '../../features/auth/presentation/screens/login_page.dart';

import '../../features/home/presentation/screens/home_page.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  final AuthStateBloc authStateBloc;

  AppRouter(this.authStateBloc);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authStateBloc.stream),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      // GoRoute(
      //   path: '/register',
      //   builder: (context, state) => const RegisterPage(),
      // ),
    ],
    redirect: (BuildContext context, GoRouterState state) {

      final isAuthenticated = authStateBloc.state is Authenticated;
      final isLoginRoute = state.matchedLocation == '/login';


      if (!isAuthenticated && !isLoginRoute) {
   
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {

        return '/';
      }

      return null;
    },
  );
}