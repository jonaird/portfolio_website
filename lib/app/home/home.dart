import 'package:website/app/home/projects/motion_blur_demo.dart';
import 'package:website/main.dart';
export './projects/projects.dart';
export 'helpers.dart';
export 'project_selector.dart';
export 'header.dart';

class HomeViewModel extends EmitterContainer {
  @override
  AppViewModel get parent => super.parent as AppViewModel;
  final motionBlur = MotionBlurViewModel();
  final showFullBio = ValueEmitter(false);

  late final showHome = ValueEmitter.reactive(
    reactTo: [parent.focalPiece],
    withValue: () => parent.focalPiece.stage != FocalPieceStages.firstBuild,
  );
  late final blurAmount = ValueEmitter.reactive(
    reactTo: [parent.focalPiece],
    withValue: () {
      if (parent.focalPiece.stage == FocalPieceStages.contact) return 4.0;
      return 0.0;
    },
  );
  late final showBackButton = ValueEmitter.reactive(
    reactTo: [parent],
    withValue: () => parent.selectedProject != null,
  );
  late final title = ValueEmitter.reactive(
    reactTo: [parent],
    withValue: () => parent.selectedProject?.title ?? 'Portfolio',
  );
  late final disableScrolling = ValueEmitter.reactive(
      reactTo: [parent], withValue: () => parent.selectedProject != null);

  void handleBackButton() {
    parent.selectedProject = null;
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeHider(
      child: AppBlur(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const _Title(),
                automaticallyImplyLeading: false,
                leading: const _Leading(),
              ),
              body: ScaffoldCapture(
                child: Stack(
                  children: [
                    Reprovider<AppViewModel, ProjectSelectorViewModel>(
                        selector: (vm) => vm.projectSelector,
                        child: const ProjectSelector()),
                    const ProjectContentOverlay(),
                    const ThemeSwitcher()
                  ],
                ),
              ),
            ),
            BuiltWithFlutterCornerBanner.positioned(
              bannerPosition: CornerBannerPosition.topRight,
              bannerColor: Theme.of(context).primaryColorLight,
              elevation: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Title
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<String>> {
  const _Title();

  @override
  ValueEmitter<String> select(HomeViewModel emitter) {
    return emitter.title;
  }

  @override
  Widget reprovide(BuildContext context, title) {
    return Text(title.value);
  }
}

class _Leading
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<bool>> {
  const _Leading();

  @override
  ValueEmitter<bool> select(HomeViewModel emitter) {
    return emitter.showBackButton;
  }

  @override
  Widget reprovide(BuildContext context, showBackButton) {
    return showBackButton.value
        ? BackButton(
            onPressed: context.read<HomeViewModel>()!.handleBackButton,
          )
        : const SizedBox();
  }
}

class HomePage
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<bool>> {
  const HomePage({super.key});

  @override
  select(emitter) => emitter.disableScrolling;

  @override
  Widget reprovide(BuildContext context, disableScrolling) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        fit: BoxFit.none,
        alignment: Alignment.center,
        child: SizedBox(
          width: context.windowSize.width,
          height: context.windowSize.height + 400,
          child: ListView(
            physics: disableScrolling.value
                ? const NeverScrollableScrollPhysics()
                : null,
            children: const [
              Gap(200),
              Header(),
              Gap(48),
              ProjectSection(),
              Gap(348),
            ],
          ),
        ),
      ),
    );
  }
}
