import 'package:aora/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './injections/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_state/auth_state_bloc.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = di.sl<AuthStateBloc>();
    final appRouter = di.sl<AppRouter>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthStateBloc>.value(
          value: authBloc..add(CheckAuthStatus()),
        ),
        BlocProvider<LoginBloc>(create: (_) => di.sl<LoginBloc>()),
      ],
      child: MaterialApp.router(
        key: ValueKey(authBloc.state),
        theme: AppTheme.theme,
        routerConfig: appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
