import 'package:website/main.dart';
export 'theme.dart';
export 'copy.dart';

class AppViewModel extends RootEmitter {
  final focalPiece = FocalPieceViewModel();
  final projectSelector = ProjectSelectorViewModel();
  final home = HomeViewModel();
  final theme = ValueEmitter(Brightness.dark);

  set initialRoute(Project? project) {
    if (project != null) {
      focalPiece.changes.listen((event) {
        if (focalPiece.introSequenceCompleted) {
          projectSelector.selectedProject.value = project;
        }
      });
    }
  }

  Project? get selectedProject => projectSelector.selectedProject.value;

  set selectedProject(Project? newSelection) =>
      projectSelector.selectedProject.value = newSelection;

  late void Function(String message) showSnackBar;

  void captureScaffoldMessanger(ScaffoldMessengerState messanger) {
    showSnackBar = (String message) => messanger.showSnackBar(
          SnackBar(
            content: Center(child: Text(message)),
            behavior: SnackBarBehavior.floating,
            width: 330,
          ),
        );
  }

  @override
  get children => {
        projectSelector,
        focalPiece,
        home,
        theme,
      };
}

class App extends StatelessWidget {
  const App({super.key});

  static final viewModel = AppViewModel();

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;
    return Provider<AppViewModel>(
      vm,
      child: Reprovider<AppViewModel, ValueEmitter<Brightness>>(
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
