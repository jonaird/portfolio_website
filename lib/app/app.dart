import 'package:website/main.dart';
import 'theme.dart';

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

  String get title => selectedProject.value?.title ?? 'Portfolio';

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

class ProjectContentOverlay extends StatelessWidgetConsumer<AppViewModel> {
  const ProjectContentOverlay({super.key});

  @override
  Widget consume(BuildContext context, vm) {
    if (!vm.animating.value && vm.selectedProject.isNotNull) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [vm.selectedProject.value!.content, const ThemeSwitcher()],
        ),
      );
    }
    return const SizedBox();
  }
}

class ScaffoldCapture extends StatelessWidget {
  const ScaffoldCapture({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    context
        .read<AppViewModel>()!
        .setScaffoldMessanger(ScaffoldMessenger.of(context));
    return child;
  }
}

class ThemeSwitcher
    extends StatelessWidgetReprovider<AppViewModel, ValueEmitter<AppTheme>> {
  const ThemeSwitcher({
    super.key,
  });

  @override
  select(appViewModel) => appViewModel.theme;

  @override
  Widget reprovide(BuildContext context, theme) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
        child: IconButton(
          onPressed: theme.toggle,
          icon: Icon(
            switch (theme.value) {
              AppTheme.light => Icons.dark_mode_outlined,
              AppTheme.dark => Icons.light_mode_outlined
            },
          ),
        ),
      ),
    );
  }
}
