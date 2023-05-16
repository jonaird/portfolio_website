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
    with ListenableEmitterMixin<ContainerChange>
    implements RouterDelegate<AppRouterConfig> {
  RouterDelegateState(this.child, this.appViewModel);
  final Widget child;
  final AppViewModel appViewModel;

  @override
  Widget build(BuildContext context) {
    return Provider(appViewModel, child: child);
  }

  @override
  Future<bool> popRoute() {
    throw UnimplementedError();
  }

  @override
  AppRouterConfig? get currentConfiguration =>
      AppRouterConfig(appViewModel.destination.value);

  @override
  Future<void> setInitialRoutePath(AppRouterConfig configuration) async {
    appViewModel.initialDestination = configuration.destination;
  }

  @override
  Future<void> setNewRoutePath(AppRouterConfig configuration) async {
    appViewModel.destination.value = configuration.destination;
  }

  @override
  Future<void> setRestoredRoutePath(AppRouterConfig configuration) {
    throw UnimplementedError();
  }

  @override
  Set<ChangeEmitter> get children => {appViewModel};

  @override
  get dependencies => {appViewModel.destination};
}
