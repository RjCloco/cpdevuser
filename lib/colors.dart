import 'package:flutter/material.dart';

class HexColors extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColors(final String hexColor) : super(_getColorFromHex(hexColor));
}

class GlobalColors {
  static HexColors OtpBox = HexColors('#D9D9D9');
  static HexColors BtnGreen = HexColors('#00554A');
  static HexColors Green = HexColors('#04AD95');
  static HexColors Grey = HexColors('#a9a9a9');
  static HexColors white = HexColors('#FFFFFF');
  static HexColors BtnWhite = HexColors('#FFFFFF');
  static HexColors ThemeColor = HexColors('#4a635a');
  static HexColors BottomNavIcon = HexColors('#0B5B55');
  static Color color1 = const Color(0xFF04AD95);
  static Color color2 = const Color(0xFF0B5B55);
  static Color color3 = const Color(0xFF060606);
  static Color color4 = const Color(0xFFFFFFFF);
  static Color color5 = const Color(0xFF012D27);
  static Color color6 = const Color(0xFF04AD95);
  static Color color7 = const Color(0xFFE8ECF4);
}
