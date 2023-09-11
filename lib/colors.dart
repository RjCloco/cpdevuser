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
  static Color twowheeler1 = const Color(0xff43e97b);
  static Color twowheeler2 = const Color(0xff38f9d7);
  static Color fourwheeler1 = const Color(0xff4facfe);
  static Color fourwheeler2 = const Color(0xff00f2fe);
  static Color heavy1 = const Color(0xfffa709a);
  static Color heavy2 = const Color(0xfffee140);
  static Color fast_ccs2_1 = const Color(0xff6a11cb);
  static Color slow_type2_1 =  HexColors('#FF60CB');
  static Color slow_type2_2 = HexColors('#E60A9E');
  static Color slow_15a_1 = const Color(0xff00c6fb);
  static Color slow_15a_2 = const Color(0xff005bea);
  static Color fast_dc_001_1 = const Color(0xfff43b47);
  static Color fast_dc_001_2= const Color(0xfff43b47);
  static Color fast_CHAde_1 = const Color(0xff43aeec);
  static Color fast_CHAde_2= const Color(0xff38f9d7);
  static Color slowIEcAC_1 = const Color(0xffffb199);
  static Color slowIEcAC_2= const Color(0xffffb199);
  static Color fasttype6_1 = const Color(0xff16a085);
  static Color fasttype6_2= const Color(0xfff4d03f);


}
