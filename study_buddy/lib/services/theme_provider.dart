import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeMode _themeMode =
      ThemeMode.light;

  ThemeMode get themeMode =>
      _themeMode;

  bool get isDarkMode =>
      _themeMode == ThemeMode.dark;

  void toggleTheme() {

    _themeMode =
        _themeMode == ThemeMode.light

            ? ThemeMode.dark

            : ThemeMode.light;

    notifyListeners();
  }

  ThemeData get lightTheme {

    return ThemeData(

      useMaterial3: true,

      brightness:
          Brightness.light,

      primarySwatch:
          Colors.blue,

      scaffoldBackgroundColor:
          Colors.grey.shade100,

      appBarTheme:
          const AppBarTheme(

        centerTitle: true,

        elevation: 0,
      ),

      cardTheme:
          CardThemeData(

        elevation: 2,

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),
      ),

      inputDecorationTheme:
          InputDecorationTheme(

        filled: true,

        fillColor:
            Colors.white,

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            14,
          ),

          borderSide:
              const BorderSide(

            color: Colors.blue,

            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme:
          ElevatedButtonThemeData(

        style:
            ElevatedButton.styleFrom(

          minimumSize:
              const Size.fromHeight(
            50,
          ),

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),
    );
  }

  ThemeData get darkTheme {

    return ThemeData.dark().copyWith(

      useMaterial3: true,

      scaffoldBackgroundColor:
          const Color(0xff121212),

      cardColor:
          const Color(0xff1E1E1E),

      appBarTheme:
          const AppBarTheme(

        centerTitle: true,

        elevation: 0,
      ),

      cardTheme:
          CardThemeData(

        elevation: 2,

        color:
            const Color(0xff1E1E1E),

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),
      ),

      inputDecorationTheme:
          InputDecorationTheme(

        filled: true,

        fillColor:
            const Color(0xff1E1E1E),

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            14,
          ),

          borderSide:
              const BorderSide(

            color: Colors.blue,

            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme:
          ElevatedButtonThemeData(

        style:
            ElevatedButton.styleFrom(

          minimumSize:
              const Size.fromHeight(
            50,
          ),

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),
    );
  }
}