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
    appBarTheme: AppBarTheme(
      backgroundColor: switch (brightness) {
        Brightness.dark => Colors.blueGrey.shade700,
        Brightness.light => Colors.blueGrey.shade500,
      },
    ),
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
        Brightness.light => Colors.white
      },
      onBackground: onColor,
      surface: switch (brightness) {
        Brightness.dark => Colors.blueGrey.shade700,
        Brightness.light => Colors.blueGrey.shade200
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
      displaySmall: baseTextTheme.displaySmall!.copyWith(
        color: textColor.withAlpha(200),
        letterSpacing: -1.5,
        height: 1.3,
      ),
      displayMedium: baseTextTheme.displayMedium!.copyWith(
        color: textColor.withAlpha(200),
        height: 1.11,
        letterSpacing: -1.5,
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
