import './main.dart';

extension StateExtensions on State {
  Size get size {
    return MediaQuery.of(context).size;
  }

  void rebuild() {
    setState(() {});
  }
}

extension StatelessExtensions on StatelessWidget {
  Size size(BuildContext context) => MediaQuery.of(context).size;
}

extension ContextExtensions on BuildContext {
  Size get windowSize => MediaQuery.of(this).size;

  bool get atHome => depend<AppState>()!.destination.value == Destinations.home;

  AppState get appState => read<AppState>()!;
}
