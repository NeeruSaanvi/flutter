import 'package:flutter/material.dart';

const double kDefaultPadding = 16.0;
const double kBottomBarHeight = 90.0;
const double kIconButtonHeight = 42;

const pink = Color(0xFFC424FF);
const blue = Color(0XFF206AFF);

const linearPinkBlueGradient = LinearGradient(colors: [pink, blue]);
const linearBluePinkGradient = LinearGradient(colors: [blue, pink]);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: pink,
  textTheme: lightTextTheme,
);

ThemeData darkTheme = ThemeData(brightness: Brightness.dark);

TextTheme lightTextTheme = const TextTheme(
  subtitle1:
      TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Thicccboi'),
  bodyText1:
      TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Thicccboi'),
  bodyText2:
      TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Thicccboi'),
  headline6:
      TextStyle(fontSize: 23, color: Colors.white, fontFamily: 'Thicccboi'),
  headline5:
      TextStyle(fontSize: 26, color: Colors.white, fontFamily: 'Thicccboi'),
  headline4:
      TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Thicccboi'),
);
