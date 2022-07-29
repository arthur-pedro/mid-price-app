import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor blue = MaterialColor(
    0xff012970, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffe5e9f0), //10%
      100: Color(0xffccd4e2), //20%
      200: Color(0xffb2bed4), //30%
      300: Color(0xff99a9c5), //40%
      400: Color(0xff8094b7), //50%
      500: Color(0xff667ea9), //60%
      600: Color(0xff4d699a), //70%
      700: Color(0xff33538c), //80%
      800: Color(0xff1a3e7e), //90%
      900: Color(0xff012970), //100%
    },
  );
} // you c
