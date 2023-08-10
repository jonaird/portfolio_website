import 'dart:async';

import 'package:website/main.dart';
export 'theme.dart';
export 'copy.dart';

class AppViewModel extends RootEmitter {
  final focalPiece = FocalPieceViewModel();
  final projectSelector = ProjectSelectorViewModel();
  final home = HomeViewModel();
  final theme = ValueEmitter(Brightness.dark);

  void onProjectSelected() {
    if (selectedProject != null) {
      focalPiece.stage = FocalPieceStages.fab;
    }

    if (selectedProject == null && home.nearBottomOfScrollView) {
      focalPiece.stage = FocalPieceStages.contact;
    }
  }

  set initialRoute(Project? project) {
    if (project != null) {
      late final StreamSubscription sub;
      sub = focalPiece.changes.listen((event) {
        if (focalPiece.introSequenceCompleted) {
          projectSelector.selectedProject = project;
          sub.cancel();
        }
      });
    }
  }

  Project? get selectedProject => projectSelector.selectedProject;

  void goToContactMeSection() async {
    if (projectSelector.selectedProject != null) {
      projectSelector.selectedProject = null;
      await Future.delayed(const Duration(milliseconds: 400));
    }
    await home.animateToContactCard();
    if (home.contactMe.focusNodes.values.every((node) => !node.hasFocus)) {
      home.contactMe.focusNodes[home.contactMe.nameField]!.requestFocus();
    }
  }

  void sendMessage() async {
    final success = await home.contactMe.sendMessage();
    if (success) {
      findAncestorOfExactType<AppViewModel>()!.onMessageSent();
    }
  }

  set selectedProject(Project? newSelection) =>
      projectSelector.selectedProject = newSelection;

  void onMessageSent() => home.onMessageSent();

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
