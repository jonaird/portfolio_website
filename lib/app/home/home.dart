import 'package:website/main.dart';
export './projects/projects.dart';

class HomeViewModel extends EmitterContainer {
  @override
  AppViewModel get parent => super.parent as AppViewModel;

  final showFullBio = ValueEmitter(false);
  late final showMainApp = ValueEmitter.reactive(
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
      reactTo: [parent.selectedProject],
      withValue: () => parent.selectedProject.value != null);

  void handleBackButton() {
    parent.selectedProject.value = null;
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Reprovider<HomeViewModel, ValueEmitter<bool>>(
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
                body: const ScaffoldCapture(
                  child: Stack(
                    children: [
                      ProjectSelector(),
                      ProjectContentOverlay(),
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
      },
    );
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

class AppBlur
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<double>> {
  const AppBlur({super.key, required this.child});
  final Widget child;

  @override
  ValueEmitter<double> select(vm) => vm.blurAmount;

  @override
  Widget reprovide(BuildContext context, blurAmount) {
    return AnimatedBlur(
      blur: blurAmount.value,
      curve: FocalPieceViewModel.animationCurve,
      child: child,
    );
  }
}

class HomePage extends StatelessWidgetConsumer<AppViewModel> {
  const HomePage({super.key});

  @override
  Widget consume(BuildContext context, vm) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        fit: BoxFit.none,
        alignment: Alignment.center,
        child: SizedBox(
          width: context.windowSize.width,
          height: context.windowSize.height + 400,
          child: ListView(
            physics: vm.selectedProject.value == null
                ? null
                : const NeverScrollableScrollPhysics(),
            children: const [
              Gap(200),
              Bio(),
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

const _shortBio =
    "I’m from Chicago but I live in Hungary with my wife and 2 year old son. I’m a full stack developer, Flutter specialist and product designer.";

const _longBio =
    "\nIn 2018 I dropped out of a math degree at Roosevelt University to persue a startup at the intersection of cryptocurrency and social media. I taught myself how to code, graduated from the Founder Institute, raised a venture funding round, hired a developer and released a product to market. Unfortunately, due to extenuating circumstances, I had to shut the company down in July 2022. After taking a much-needed sabbatical, I’m excited to reenter the workforce!";

class Bio extends StatelessWidget {
  const Bio({super.key});

  @override
  Widget build(BuildContext context) {
    return Reprovider<HomeViewModel, ValueEmitter<bool>>(
        selector: (vm) => vm.showFullBio,
        builder: (context, showFullBio) {
          return Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: 730,
                child: Column(
                  children: [
                    const Gap(80),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi! My name is',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              RichText(
                                  text: TextSpan(
                                children: [
                                  const TextSpan(text: "Jonathan Aird\nand "),
                                  TextSpan(
                                    text: 'I build apps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  )
                                ],
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              )),
                            ],
                          ),
                          const Gap(101),
                          Material(
                            color: Theme.of(context).colorScheme.surface,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: 225,
                                height: 225,
                                child: Image.asset('assets/headshot.jpeg'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    Text(
                      _shortBio,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: showFullBio.value
                            ? Text(
                                _longBio,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            : Container(
                                alignment: Alignment.topCenter,
                                height: 1,
                                width: 730,
                                child: FittedBox(
                                  fit: BoxFit.none,
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: 730,
                                    child: Text(
                                      _longBio,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const Gap(12),
                    TextButton(
                      onPressed: showFullBio.toggle,
                      child: Text(
                        showFullBio.value ? "Less about me" : 'More about me',
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
