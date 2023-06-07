import 'package:website/main.dart';

enum AppTheme {
  dark,
  light;

  ThemeData get themeData {
    return switch (this) {
      AppTheme.light => _lightTheme,
      AppTheme.dark => _darkTheme
    };
  }
}

extension ThemeToggle on ValueEmitter<AppTheme> {
  void toggle() {
    value = switch (value) {
      AppTheme.light => AppTheme.dark,
      AppTheme.dark => AppTheme.light
    };
  }
}

const _textTheme = Typography.whiteHelsinki;
const _textThemeDark = Typography.blackHelsinki;
final _darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.blueGrey.shade900,
  primaryColorLight: Colors.blueGrey.shade400,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.blueGrey.shade800,
    onPrimary: Colors.white,
    secondary: Colors.redAccent.shade200,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: Colors.blueGrey.shade900,
    onBackground: Colors.white,
    surface: Colors.blueGrey.shade700,
    onSurface: Colors.white,
  ),
  textTheme: _textTheme.copyWith(
    bodyLarge: _textTheme.bodyMedium!.copyWith(
        fontSize: 24,
        color: Colors.white.withAlpha(170),
        fontWeight: FontWeight.w100),
    displaySmall: _textTheme.displaySmall!.copyWith(
      color: Colors.white.withAlpha(200),
    ),
    displayMedium: _textTheme.displayMedium!.copyWith(
      color: Colors.white.withAlpha(200),
      height: 0.98,
    ),
    displayLarge: _textTheme.displayLarge!.copyWith(
      fontSize: 84,
      color: Colors.white.withAlpha(200),
      height: 0.98,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.lightBlue.shade600,
    ),
  ),
);
final _lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade50,
  primaryColorLight: Colors.blueGrey.shade300,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blueGrey.shade500,
    onPrimary: Colors.white,
    secondary: Colors.redAccent.shade200,
    onSecondary: Colors.blueGrey.shade50,
    error: Colors.red,
    onError: Colors.white,
    background: Colors.blueGrey.shade100,
    onBackground: Colors.black,
    surface: Colors.grey.shade300,
    onSurface: Colors.black,
  ),
  textTheme: _textThemeDark.copyWith(
    bodyLarge: _textThemeDark.bodyMedium!.copyWith(
        fontSize: 24,
        color: Colors.black.withAlpha(170),
        fontWeight: FontWeight.w100),
    displaySmall: _textThemeDark.displaySmall!.copyWith(
      color: Colors.black.withAlpha(200),
    ),
    displayMedium: _textThemeDark.displayMedium!.copyWith(
      color: Colors.black.withAlpha(200),
      height: 0.98,
    ),
    displayLarge: _textThemeDark.displayLarge!.copyWith(
      fontSize: 84,
      color: Colors.black.withAlpha(200),
      height: 0.98,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.lightBlue.shade600,
    ),
  ),
);
