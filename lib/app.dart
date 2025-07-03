import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/splash_screen.dart';

class DearDiaryApp extends StatelessWidget {
  const DearDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DearDiary',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const SplashScreen(),
    );
  }
}
