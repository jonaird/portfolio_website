import 'package:website/main.dart';
export 'theme.dart';

class AppViewModel extends RootEmitter {
  late final Project? initialRoute;
  final selectedProject = ValueEmitter<Project?>(null, keepHistory: true);
  final animating = ValueEmitter<bool>(false);
  final focalPiece = FocalPieceViewModel();
  final home = HomeViewModel();
  final theme = ValueEmitter(AppTheme.dark);

  ScaffoldMessengerState? _scaffoldMessenger;

  void selectProject(Project project) {
    selectedProject.value = project;
    animating.value = true;
  }

  void setScaffoldMessanger(ScaffoldMessengerState messanger) =>
      _scaffoldMessenger = messanger;

  void showSnackBarMessage(String message) {
    _scaffoldMessenger?.showSnackBar(SnackBar(
      content: Center(child: Text(message)),
      behavior: SnackBarBehavior.floating,
      width: 330,
    ));
  }

  bool showProjectContent(Project project) {
    return selectedProject.value == project ||
        (selectedProject.previous == project && animating.value);
  }

  @override
  get children => {
        selectedProject,
        focalPiece,
        home,
        theme,
      };
  @override
  get dependencies => {selectedProject, animating};
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = AppViewModel();
    return Provider<AppViewModel>(
      vm,
      child: Reprovider<AppViewModel, ValueEmitter<AppTheme>>(
        selector: (vm) => vm.theme,
        builder: (context, theme) {
          return MaterialApp.router(
            routeInformationParser: RouteInfoParser(),
            routerDelegate: RouterDelegateState(vm),
            theme: theme.value.themeData,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class RouterChild extends StatelessWidget {
  const RouterChild({super.key});

  @override
  Widget build(BuildContext context) {
    return AppOverlay(
      child: Stack(
        children: [
          Reprovider(
            selector: (AppViewModel vm) => vm.home,
            child: const Home(),
          ),
          Reprovider(
            selector: (AppViewModel appViewModel) => appViewModel.focalPiece,
            child: const FocalPiece(),
          ),
        ],
      ),
    );
  }
}

class AppOverlay extends StatelessWidget {
  const AppOverlay({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [OverlayEntry(builder: (context) => child)],
    );
  }
}
