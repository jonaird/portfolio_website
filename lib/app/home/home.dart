import 'package:website/main.dart';
export './projects/projects.dart';
export 'helpers.dart';
export 'project_selector.dart';

class HomeViewModel extends EmitterContainer {
  @override
  AppViewModel get parent => super.parent as AppViewModel;

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

class ThemeSwitcher
    extends StatelessWidgetReprovider<AppViewModel, ValueEmitter<Brightness>> {
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
              Brightness.light => Icons.dark_mode_outlined,
              Brightness.dark => Icons.light_mode_outlined
            },
          ),
        ),
      ),
    );
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

const _shortBio =
    "I’m from Chicago and I live in Hungary with my wife and 2 year old son. I’m a full stack developer, Flutter specialist and product designer.";

const _longBio =
    "\nIn 2018 I dropped out of a math degree at Roosevelt University to persue a startup at the intersection of cryptocurrency and social media. I taught myself how to code, graduated from the Founder Institute, raised a venture funding round, hired a developer and released a product to market. Unfortunately, due to extenuating circumstances, I had to shut the company down in July 2022. After taking a much-needed sabbatical, I’m excited to reenter the workforce!";

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: 730,
          child: Column(
            children: [
              Gap(80),
              Intro(),
              Gap(60),
              ExpandableBio(),
            ],
          ),
        ),
      ),
    );
  }
}

class Intro extends StatelessWidget {
  const Intro({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
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
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  )
                ],
                style: Theme.of(context).textTheme.displayMedium,
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
    );
  }
}

class ExpandableBio
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<bool>> {
  const ExpandableBio({super.key});

  @override
  ValueEmitter<bool> select(HomeViewModel vm) => vm.showFullBio;

  @override
  Widget reprovide(BuildContext context, showFullBio) {
    return SizedBox(
      width: 700,
      child: Column(
        children: [
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
                      width: 700,
                      child: FittedBox(
                        fit: BoxFit.none,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 700,
                          child: Text(
                            _longBio,
                            style: Theme.of(context).textTheme.bodyLarge,
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
          ),
        ],
      ),
    );
  }
}
