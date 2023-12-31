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
}
