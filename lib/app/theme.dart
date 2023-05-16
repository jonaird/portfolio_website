import 'package:website/main.dart';

const _textTheme = Typography.whiteHelsinki;
final appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.blueGrey.shade900,
  primaryColorLight: Colors.blueGrey.shade400,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.blueGrey.shade700,
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
