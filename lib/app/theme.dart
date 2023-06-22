import 'package:website/main.dart';
import 'package:google_fonts/google_fonts.dart';

extension ThemeToggle on ValueEmitter<Brightness> {
  void toggle() {
    value = switch (value) {
      Brightness.light => Brightness.dark,
      Brightness.dark => Brightness.light
    };
  }
}

extension ThemeDataExtension on Brightness {
  ThemeData get themeData => _themeFromBrightness(this);
}

ThemeData _themeFromBrightness(Brightness brightness) {
  final baseTextTheme = switch (brightness) {
    Brightness.dark => Typography.whiteHelsinki,
    Brightness.light => Typography.blackHelsinki
  };
  final textColor = switch (brightness) {
    Brightness.light => Colors.black.withAlpha(200),
    Brightness.dark => Colors.white.withAlpha(200)
  };
  final onColor = switch (brightness) {
    Brightness.light => Colors.black,
    Brightness.dark => Colors.white
  };

  return ThemeData(
    scaffoldBackgroundColor: switch (brightness) {
      Brightness.dark => Colors.blueGrey.shade900,
      Brightness.light => Colors.blueGrey.shade50
    },
    primaryColorLight: switch (brightness) {
      Brightness.dark => Colors.blueGrey.shade400,
      Brightness.light => Colors.blueGrey.shade300
    },
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: switch (brightness) {
        Brightness.dark => Colors.blueGrey.shade800,
        Brightness.light => Colors.blueGrey.shade400
      },
      onPrimary: Colors.white,
      secondary: Colors.redAccent.shade200,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: switch (brightness) {
        Brightness.dark => Colors.blueGrey.shade900,
        Brightness.light => Colors.blueGrey.shade50
      },
      onBackground: onColor,
      surface: switch (brightness) {
        Brightness.dark => Colors.blueGrey.shade700,
        Brightness.light => Colors.blueGrey.shade100
      },
      onSurface: onColor,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.petrona(
        fontSize: 24,
        color: textColor.withAlpha(185),
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: baseTextTheme.bodyMedium!.copyWith(
        fontSize: 20,
        color: textColor.withAlpha(170),
        fontWeight: FontWeight.w100,
      ),

      // bodyText1: GoogleFonts.lora(
      //   fontSize: 24,
      //   color: textColor.withAlpha(185),
      //   fontWeight: FontWeight.w100,
      // ),
      // bodyText1: GoogleFonts.lora(
      //   fontSize: 20,
      //   color: textColor.withAlpha(185),
      //   fontWeight: FontWeight.w300,
      // ),
      displaySmall: baseTextTheme.displaySmall!.copyWith(
        color: textColor.withAlpha(200),
        letterSpacing: -1,
        height: 1.4,
      ),
      displayMedium: baseTextTheme.displayMedium!.copyWith(
        color: textColor.withAlpha(200),
        height: 1.12,
        letterSpacing: -1,
      ),
      displayLarge: baseTextTheme.displayLarge!.copyWith(
        fontSize: 74,
        color: textColor.withAlpha(200),
        height: 0.98,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.lightBlue.shade600,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.redAccent.shade200,
      selectionColor: Colors.redAccent.shade200,
    ),
    scrollbarTheme: const ScrollbarThemeData(
        thumbVisibility: MaterialStatePropertyAll(true)),
  );
}



// TextTheme _textThemeFromBrightness(Brightness brightness) {
//   final baseTextTheme = brightness == Brightness.light
//       ? Typography.blackHelsinki
//       : Typography.whiteHelsinki;
//   final textColor = brightness == Brightness.light
//       ? Colors.black.withAlpha(200)
//       : Colors.white.withAlpha(200);

//   return baseTextTheme.copyWith(
//     bodyLarge: GoogleFonts.lora(
//       fontSize: 24,
//       color: textColor.withAlpha(185),
//       fontWeight: FontWeight.w100,
//     ),
//     // bodyMedium: _textTheme.bodyMedium!.copyWith(
//     //   fontSize: 20,
//     //   color: Colors.white.withAlpha(170),
//     //   fontWeight: FontWeight.w100,
//     // ),
//     bodyMedium: GoogleFonts.lora(
//       fontSize: 20,
//       color: textColor.withAlpha(185),
//       fontWeight: FontWeight.w300,
//     ),
//     displaySmall: _textTheme.displaySmall!.copyWith(
//       color: textColor.withAlpha(200),
//     ),
//     displayMedium: _textTheme.displayMedium!.copyWith(
//       color: textColor.withAlpha(200),
//       height: 0.98,
//     ),
//     displayLarge: _textTheme.displayLarge!.copyWith(
//       fontSize: 84,
//       color: textColor.withAlpha(200),
//       height: 0.98,
//     ),
//   );
// }

// ColorScheme _colorSchemFromBrightness(Brightness brightness) {
//   final onColor = switch (brightness) {
//     Brightness.light => Colors.black,
//     Brightness.dark => Colors.white
//   };
//   return ColorScheme(
//     brightness: brightness,
//     primary: switch (brightness) {
//       Brightness.dark => Colors.blueGrey.shade800,
//       Brightness.light => Colors.blueGrey.shade400
//     },
//     onPrimary: onColor,
//     secondary: Colors.redAccent.shade200,
//     onSecondary: Colors.white,
//     error: Colors.red,
//     onError: Colors.white,
//     background: switch (brightness) {
//       Brightness.dark => Colors.blueGrey.shade900,
//       Brightness.light => Colors.blueGrey.shade100
//     },
//     onBackground: onColor,
//     surface: switch (brightness) {
//       Brightness.dark => Colors.blueGrey.shade700,
//       Brightness.light => Colors.blueGrey.shade200
//     },
//     onSurface: onColor,
//   );
// }

// const _textTheme = Typography.whiteHelsinki;
// const _textThemeDark = Typography.blackHelsinki;
// final _darkTheme = ThemeData(
//   scaffoldBackgroundColor: Colors.blueGrey.shade900,
//   primaryColorLight: Colors.blueGrey.shade400,
//   colorScheme: ColorScheme(
//     brightness: Brightness.dark,
//     primary: Colors.blueGrey.shade800,
//     onPrimary: Colors.white,
//     secondary: Colors.redAccent.shade200,
//     onSecondary: Colors.white,
//     error: Colors.red,
//     onError: Colors.white,
//     background: Colors.blueGrey.shade900,
//     onBackground: Colors.white,
//     surface: Colors.blueGrey.shade700,
//     onSurface: Colors.white,
//   ),
//   textTheme: _textTheme.copyWith(
//     bodyLarge: GoogleFonts.lora(
//       fontSize: 24,
//       color: Colors.white.withAlpha(185),
//       fontWeight: FontWeight.w100,
//     ),
//     // bodyMedium: _textTheme.bodyMedium!.copyWith(
//     //   fontSize: 20,
//     //   color: Colors.white.withAlpha(170),
//     //   fontWeight: FontWeight.w100,
//     // ),
//     bodyMedium: GoogleFonts.lora(
//       fontSize: 20,
//       color: Colors.white.withAlpha(185),
//       fontWeight: FontWeight.w300,
//     ),
//     displaySmall: _textTheme.displaySmall!.copyWith(
//       color: Colors.white.withAlpha(200),
//     ),
//     displayMedium: _textTheme.displayMedium!.copyWith(
//       color: Colors.white.withAlpha(200),
//       height: 0.98,
//     ),
//     displayLarge: _textTheme.displayLarge!.copyWith(
//       fontSize: 84,
//       color: Colors.white.withAlpha(200),
//       height: 0.98,
//     ),
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: TextButton.styleFrom(
//       foregroundColor: Colors.lightBlue.shade600,
//     ),
//   ),
//   textSelectionTheme: TextSelectionThemeData(
//     cursorColor: Colors.redAccent.shade200,
//     selectionColor: Colors.redAccent.shade200,
//   ),
//   scrollbarTheme:
//       const ScrollbarThemeData(thumbVisibility: MaterialStatePropertyAll(true)),
// );
// final _lightTheme = ThemeData(
//   scaffoldBackgroundColor: Colors.blueGrey.shade100,
//   primaryColorLight: Colors.blueGrey.shade300,
//   colorScheme: ColorScheme(
//     brightness: Brightness.light,
//     primary: Colors.blueGrey.shade500,
//     onPrimary: Colors.white,
//     secondary: Colors.redAccent.shade200,
//     onSecondary: Colors.blueGrey.shade50,
//     error: Colors.red,
//     onError: Colors.white,
//     background: Colors.blueGrey.shade100,
//     onBackground: Colors.black,
//     surface: Colors.grey.shade300,
//     onSurface: Colors.black,
//   ),
//   textTheme: _textThemeDark.copyWith(
//     bodyLarge: _textThemeDark.bodyMedium!.copyWith(
//         fontSize: 24,
//         color: Colors.black.withAlpha(170),
//         fontWeight: FontWeight.w100),
//     displaySmall: _textThemeDark.displaySmall!.copyWith(
//       color: Colors.black.withAlpha(200),
//     ),
//     displayMedium: _textThemeDark.displayMedium!.copyWith(
//       color: Colors.black.withAlpha(200),
//       height: 0.98,
//     ),
//     displayLarge: _textThemeDark.displayLarge!.copyWith(
//       fontSize: 84,
//       color: Colors.black.withAlpha(200),
//       height: 0.98,
//     ),
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: TextButton.styleFrom(
//       foregroundColor: Colors.lightBlue.shade600,
//     ),
//   ),
// );
