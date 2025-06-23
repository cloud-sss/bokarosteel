// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ThemeModel {
  Color lightPrimaryColor = const Color.fromARGB(244, 0, 128, 128);
  Color darkPrimaryColor = const Color.fromARGB(244, 0, 128, 128);
  Color secondaryColor = const Color.fromARGB(255, 36, 82, 235);
  //Color lightTextColor = Color.fromARGB(0, 0, 0, 0);
  Color lightTextColor = Colors.black;
  // Color lightIconColor = Color.fromARGB(244, 9, 97, 97);
  Color lightIconColor = const Color.fromARGB(244, 9, 97, 97);
  Color darkIconColor = const Color.fromARGB(248, 7, 5, 128);
  Color lightIconTextColor = Colors.black;
  Color darkIconTextColor = Colors.white;
  Image navLogoImage = Image.asset(
    'assets/bokarosteel.png',
    height: 40,
    width: 40,
  );

  // static ThemeData lightTheme = ThemeData(
  //     primaryColor: ThemeData.light().scaffoldBackgroundColor,
  //     floatingActionButtonTheme: FloatingActionButtonThemeData(
  //         backgroundColor: _themeModel.lightIconColor,
  //         extendedTextStyle: TextStyle(color: _themeModel.lightIconTextColor)),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //         style: ButtonStyle(
  //             foregroundColor: MaterialStateProperty.all(Colors.white),
  //             backgroundColor:
  //                 MaterialStatePropertyAll(_themeModel.lightPrimaryColor),
  //             textStyle: MaterialStatePropertyAll(
  //                 TextStyle(color: _themeModel.lightTextColor)))),
  //     colorScheme: const ColorScheme.light().copyWith(
  //         primary: _themeModel.lightPrimaryColor,
  //         secondary: _themeModel.secondaryColor));
  // static ThemeData darkTheme = ThemeData(
  //     primaryColor: ThemeData.dark().scaffoldBackgroundColor,
  //     floatingActionButtonTheme: FloatingActionButtonThemeData(
  //         backgroundColor: _themeModel.darkIconColor,
  //         extendedTextStyle: TextStyle(color: _themeModel.darkIconTextColor)),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //         style: ButtonStyle(
  //             foregroundColor: MaterialStateProperty.all(Colors.white),
  //             backgroundColor:
  //                 MaterialStatePropertyAll(_themeModel.darkPrimaryColor),
  //             textStyle: MaterialStatePropertyAll(
  //                 TextStyle(color: _themeModel.darkIconTextColor)))),
  //     colorScheme: const ColorScheme.dark()
  //         .copyWith(primary: _themeModel.darkPrimaryColor));

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _themeModel.lightIconColor,
      extendedTextStyle: TextStyle(color: _themeModel.lightIconTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor:
            MaterialStatePropertyAll(_themeModel.lightPrimaryColor),
        textStyle: MaterialStatePropertyAll(
          TextStyle(color: _themeModel.lightTextColor),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themeModel.lightPrimaryColor,
      secondary: _themeModel.secondaryColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    // scaffoldBackgroundColor: Colors.grey.shade800,
    scaffoldBackgroundColor: Colors.grey.shade600,

    primaryColor: Colors.grey.shade600,
    //primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _themeModel.darkIconColor,
      extendedTextStyle: TextStyle(color: _themeModel.darkIconTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStatePropertyAll(_themeModel.darkPrimaryColor),
        textStyle: MaterialStatePropertyAll(
          TextStyle(color: _themeModel.darkIconTextColor),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: Colors.white60),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeModel.darkPrimaryColor,
    ),
  );
}

ThemeModel _themeModel = ThemeModel();
