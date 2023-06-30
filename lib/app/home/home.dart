import 'package:website/app/focal_piece/contact_card.dart';
import 'package:website/app/home/projects/force_directed_graph_demo.dart';
import 'package:website/app/home/projects/motion_blur_demo.dart';
import 'package:website/main.dart';
export './projects/projects.dart';
export 'helpers.dart';
export 'project_selector.dart';
export 'header.dart';

class HomeViewModel extends EmitterContainer {
  HomeViewModel() {
    scrollController.changes.listen((change) {
      if (nearBottomOfScrollView) {
        parent.focalPiece.stage = FocalPieceStages.contact;
      } else {
        parent.focalPiece.stage = FocalPieceStages.fab;
      }
      if (change.newValue > scrollController.position.maxScrollExtent - 200 &&
          change.newValue > change.oldValue!) {
        animateToContactCard();
      }
    });
  }
  @override
  AppViewModel get parent => super.parent as AppViewModel;
  final motionBlur = MotionBlurViewModel();
  final forceDirectedGraph = ForceDirectedGraphViewModel();
  final showFullBio = ValueEmitter(false);
  final scrollController = ScrollEmitter();
  final projectScrollPositions =
      Project.values.asMap().map((key, value) => MapEntry(value, 0.0));
  var _animatingToBottom = false;

  ScrollController requestScrollConteroller(Project project) {
    final newController =
        ScrollController(initialScrollOffset: projectScrollPositions[project]!);
    newController.addListener(() {
      projectScrollPositions[project] = newController.offset;
    });
    return newController;
  }

  void animateToContactCard() {
    if (!_animatingToBottom) {
      _animatingToBottom = true;
      scrollController
          .animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: FocalPieceViewModel.animationCurve,
          )
          .then((value) => _animatingToBottom = false);
    }
  }

  bool get nearBottomOfScrollView {
    return scrollController.offset >
        scrollController.position.maxScrollExtent - 10;
  }

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

  void onMessageSent() {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent - 64 - 400,
        duration: const Duration(milliseconds: 400),
        curve: FocalPieceViewModel.animationCurve);
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeHider(
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
                      child: const ProjectSelector(child: HomePage())),
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
          child: SingleChildScrollView(
              physics: disableScrolling.value
                  ? const NeverScrollableScrollPhysics()
                  : null,
              controller: context.read<HomeViewModel>()!.scrollController,
              child: Column(
                children: [
                  const Gap(200),
                  const Header(),
                  const Gap(48),
                  const ProjectSection(),
                  const Gap(48),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Want to know how this website works? "),
                          TextButton(
                            onPressed: () => launchUrl(Uri.parse(
                                'https://github.com/jonaird/portfolio_website')),
                            child: const Text('View the source code.'),
                          )
                        ],
                      )),
                  const Gap(48),
                  Reprovider<AppViewModel, ContactCardViewModel>(
                    selector: (appVM) => appVM.focalPiece.contactCard,
                    child: const ContactCardContainer(),
                  ),
                  const Gap(264),
                ],
              )),
        ),
      ),
    );
  }
}
