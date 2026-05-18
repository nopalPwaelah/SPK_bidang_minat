import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/splash_screen.dart';
import 'core/theme/theme.dart';
import 'core/providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'SPK KNN',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}