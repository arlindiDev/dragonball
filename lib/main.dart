import 'package:flutter/material.dart';
import 'routes.dart';
import 'themes.dart';

void main() {
  runApp(const DragonBallApp());
}

class DragonBallApp extends StatelessWidget {
  const DragonBallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dragon Ball Characters',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme(),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
