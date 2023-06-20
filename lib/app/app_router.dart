import '../main.dart';

class AppRouterConfig {
  AppRouterConfig(this.selectedProject);
  final Project? selectedProject;
}

class RouteInfoParser extends RouteInformationParser<AppRouterConfig> {
  @override
  Future<AppRouterConfig> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = routeInformation.location!;
    return Future.value(AppRouterConfig(Project.fromUri(uri)));
  }

  @override
  RouteInformation? restoreRouteInformation(AppRouterConfig configuration) {
    return RouteInformation(
        location: configuration.selectedProject?.path ?? '/');
  }
}

class RouterDelegateState extends EmitterContainer
    with ListenableEmitterMixin<ContainerChange>
    implements RouterDelegate<AppRouterConfig> {
  RouterDelegateState(this.appViewModel);
  final AppViewModel appViewModel;

  @override
  Widget build(BuildContext context) {
    return const RouterChild();
  }

  @override
  Future<bool> popRoute() {
    throw UnimplementedError();
  }

  @override
  AppRouterConfig? get currentConfiguration =>
      AppRouterConfig(appViewModel.selectedProject.value);

  @override
  Future<void> setInitialRoutePath(AppRouterConfig configuration) async {
    appViewModel.initialRoute = configuration.selectedProject;
  }

  @override
  Future<void> setNewRoutePath(AppRouterConfig configuration) async {
    appViewModel.selectedProject.value = configuration.selectedProject;
  }

  @override
  Future<void> setRestoredRoutePath(AppRouterConfig configuration) {
    throw UnimplementedError();
  }

  @override
  Set<ChangeEmitter> get children => {appViewModel};

  @override
  get dependencies => {appViewModel.selectedProject};
}
