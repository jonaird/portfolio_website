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
  late final showThemeSwitcher = ValueEmitter.reactive(
    reactTo: [animating],
    withValue: () => !animating.value,
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

  String get title {
    final dest = selectedProject.value;
    if (dest is Project) return dest.title;
    return 'Portfolio';
  }

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
  get dependencies => {selectedProject, theme, animating};
}

final _appViewModel = AppViewModel();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AppViewModel>(_appViewModel,
        builder: (context, appViewModel) {
      return MaterialApp.router(
        routeInformationParser: RouteInfoParser(),
        routerDelegate:
            RouterDelegateState(const _RouterChild(), _appViewModel),
        theme: appViewModel.theme.value.themeData,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

class _RouterChild extends StatelessWidget {
  const _RouterChild();

  @override
  Widget build(BuildContext context) {
    return Overlays(
      child: Reprovider<AppViewModel, ValueEmitter<bool>>(
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
                    body: const ScaffoldCapture(child: ProjectSelector()),
                  ),
                  BuiltWithFlutterCornerBanner.positioned(
                    bannerPosition: CornerBannerPosition.topRight,
                    bannerColor: Theme.of(context).primaryColorLight,
                    elevation: 2,
                  ),
                ],
              ),
            );
          }),
    );
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

class Overlays extends StatelessWidget {
  const Overlays({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(builder: (_) => child),
        OverlayEntry(
          builder: (_) => Reprovider(
            selector: (AppViewModel appViewModel) => appViewModel.focalPiece,
            child: const FocalPieceBackground(),
          ),
        ),
        OverlayEntry(
          builder: (_) => Reprovider(
            selector: (AppViewModel appViewModel) => appViewModel.focalPiece,
            child: const FocalPiece(),
          ),
        ),
      ],
    );
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
