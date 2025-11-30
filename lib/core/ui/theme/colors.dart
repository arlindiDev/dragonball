import 'package:flutter/material.dart';

class AppColors {
  static const Color orange = Color(0xFFFF6B00);
  static const Color orangeLight = Color(0xFFFF8C00);
  static const Color blue = Color(0xFF0066CC);
  static const Color blueLight = Color(0xFF0099FF);
  static const Color purple = Color(0xFF9900CC);
  static const Color purpleLight = Color(0xFFCC00FF);
  static const Color green = Color(0xFF00CC66);
  static const Color greenLight = Color(0xFF00FF99);
  static const Color red = Color(0xFFCC0000);
  static const Color redLight = Color(0xFFFF3333);
  
  static const Color gold = Color(0xFFFFD700);
  static const Color cyan = Color(0x00FFFFFF);
  static const Color magenta = Color(0xFFFF00FF);
  static const Color lime = Color(0xFF00FF00);
  static const Color deepPink = Color(0xFFFF1493);
  
  static const List<Color> gradientOrange = [orange, orangeLight];
  static const List<Color> gradientBlue = [blue, blueLight];
  static const List<Color> gradientPurple = [purple, purpleLight];
  static const List<Color> gradientGreen = [green, greenLight];
  static const List<Color> gradientRed = [red, redLight];
  
  static List<Color> getGradientByIndex(int index) {
    switch (index % 5) {
      case 0:
        return gradientOrange;
      case 1:
        return gradientBlue;
      case 2:
        return gradientPurple;
      case 3:
        return gradientGreen;
      case 4:
        return gradientRed;
      default:
        return gradientOrange;
    }
  }
  
  static Color getTransformationColor(int index) {
    final colors = [gold, cyan, magenta, lime, deepPink];
    return colors[index % colors.length];
  }
}
