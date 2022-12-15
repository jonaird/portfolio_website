import '../main.dart';

class AppRouterConfig {
  AppRouterConfig(this.destination);
  final Destination destination;
}

class RouteInfoParser extends RouteInformationParser<AppRouterConfig> {
  @override
  Future<AppRouterConfig> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = routeInformation.location!;
    return Future.value(AppRouterConfig(Destination.fromUri(uri)));
  }

  @override
  RouteInformation? restoreRouteInformation(AppRouterConfig configuration) {
    return RouteInformation(location: configuration.destination.path);
  }
}

class RouterDelegateState extends EmitterContainer
    with ListenableEmitterMixin
    implements RouterDelegate<AppRouterConfig> {
  final AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return Provider(appState, child: const App());
  }

  @override
  Future<bool> popRoute() {
    throw UnimplementedError();
  }

  @override
  AppRouterConfig? get currentConfiguration =>
      AppRouterConfig(appState.destination.value);

  @override
  Future<void> setInitialRoutePath(AppRouterConfig configuration) async {
    appState.initialDestination = configuration.destination;
  }

  @override
  Future<void> setNewRoutePath(AppRouterConfig configuration) async {
    appState.destination.value = configuration.destination;
  }

  @override
  Future<void> setRestoredRoutePath(AppRouterConfig configuration) {
    throw UnimplementedError();
  }

  @override
  Set<ChangeEmitter> get children => {appState};

  @override
  get dependencies => {appState.destination};
}
