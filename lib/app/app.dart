import 'package:website/main.dart';
import 'theme.dart';

class AppViewModel extends RootEmitter {
  late final Project? initialRoute;
  final selectedProject = ValueEmitter<Project?>(null, keepHistory: true);
  final animating = ValueEmitter<bool>(false);
  final focalPiece = FocalPieceViewModel();
  late final showBackButton = ValueEmitter.reactive(
      reactTo: [selectedProject],
      withValue: () => selectedProject.value != null);
  final showFullBio = ValueEmitter(false);
  final theme = ValueEmitter(AppTheme.dark);
  late final showMainApp = ValueEmitter.reactive(
    reactTo: [focalPiece],
    withValue: () => focalPiece.stage != FocalPieceStages.firstBuild,
  );
  late final blurAmount = ValueEmitter.reactive(
    reactTo: [focalPiece],
    withValue: () {
      if (focalPiece.stage == FocalPieceStages.contact) return 4.0;
      return 0.0;
    },
  );

  ScaffoldMessengerState? _scaffoldMessenger;

  void handleBackButton() {
    selectedProject.value = null;
  }

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
        showMainApp,
        showBackButton,
        showFullBio,
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
          Reprovider<AppViewModel, ValueEmitter<bool>>(
            selector: (vm) => vm.showMainApp,
            builder: (context, showMainApp) {
              if (!showMainApp.value) return const SizedBox();
              return AppBlur(
                child: Stack(
                  children: [
                    Scaffold(
                      appBar: AppBar(
                        title: const _Title(),
                        automaticallyImplyLeading: false,
                        leading: const _Leading(),
                      ),
                      body: const ScaffoldCapture(child: Home()),
                    ),
                    BuiltWithFlutterCornerBanner.positioned(
                      bannerPosition: CornerBannerPosition.topRight,
                      bannerColor: Theme.of(context).primaryColorLight,
                      elevation: 2,
                    ),
                  ],
                ),
              );
            },
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        ProjectSelector(),
        ProjectContentOverlay(),
      ],
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

class AppBlur
    extends StatelessWidgetReprovider<AppViewModel, ValueEmitter<double>> {
  const AppBlur({super.key, required this.child});
  final Widget child;

  @override
  ValueEmitter<double> select(AppViewModel emitter) => emitter.blurAmount;

  @override
  Widget reprovide(BuildContext context, blurAmount) {
    return AnimatedBlur(
      blur: blurAmount.value,
      curve: FocalPieceViewModel.animationCurve,
      child: child,
    );
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

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final title = context.select<AppViewModel, String>((vm) => vm.title)!;
    return Text(
      title,
    );
  }
}

class _Leading extends StatelessWidgetConsumer<AppViewModel> {
  const _Leading();

  @override
  Widget consume(BuildContext context, vm) {
    return vm.showBackButton.value
        ? BackButton(
            onPressed: vm.handleBackButton,
          )
        : const SizedBox();
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
