import 'package:flutter/material.dart';
import 'package:midprice/theme/pallete.dart';

class CustomTheme {
  BuildContext context;
  CustomTheme({required this.context});

  TextTheme textTheme() {
    return Theme.of(context)
        .textTheme
        .apply(bodyColor: Colors.blueGrey, fontFamily: 'NunitoRegular');
  }

  TabBarTheme tabBarTheme() {
    return const TabBarTheme(labelColor: Colors.white);
  }

  MaterialColor blue() {
    return Palette.blue;
  }
}
