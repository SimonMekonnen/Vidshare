import 'package:aora/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'features/auth/presentation/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.theme, home: LoginPage());
  }
}
