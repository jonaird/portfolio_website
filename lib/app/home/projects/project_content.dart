import 'package:website/app/home/projects/force_directed_graph_demo.dart';
import 'package:website/main.dart';
import 'motion_blur_demo.dart';

enum Link {
  changeEmitterGithub(
    'View on Github',
    'https://github.com/jonaird/change_emitter',
  ),
  changeEmitterDesignDoc(
    'Read the Design Doc',
    'https://medium.com/@jonathan.aird/observable-state-trees-a-state-management-pattern-for-flutter-af62e76da1b',
  ),
  versoDesignCaseStudy(
    'Read the Design Case Study',
    'https://medium.com/@jonathan.aird/verso-design-case-study-c43c03067cfe',
  ),
  forceDirectedGraphGithub(
    'View on Github',
    'https://github.com/jonaird/force_directed_graph',
  ),
  motionBlurGithub(
    'View on Github',
    'https://github.com/jonaird/motion_blur',
  );

  const Link(this.text, this.urlString);

  final String text;
  final String urlString;

  Uri get url => Uri.parse(urlString);
}

class BsvNews extends StatelessWidget {
  const BsvNews({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SizedBox(
            width: 700,
            child: Column(
              children: [
                const Placeholder(fallbackHeight: 200),
                const Gap(24),
                ProjectText(Project.bsvNews.copy),
                const Gap(24),
                const Placeholder(fallbackHeight: 200)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeEmitterContent extends StatefulWidget {
  const ChangeEmitterContent({super.key});

  @override
  State<ChangeEmitterContent> createState() => _ChangeEmitterContentState();
}

class _ChangeEmitterContentState extends State<ChangeEmitterContent> {
  late final _controller = context
      .read<HomeViewModel>()!
      .requestScrollConteroller(Project.changeEmitter);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 700,
            child: Column(
              children: [
                const Gap(24),
                Image.asset(
                  'assets/OST.png',
                  fit: BoxFit.contain,
                  width: 650,
                ),
                const Gap(24),
                ProjectText(Project.changeEmitter.copy),
                const Gap(24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LinkButton(Link.changeEmitterGithub),
                    Gap(12),
                    LinkButton(Link.changeEmitterDesignDoc),
                  ],
                ),
                const Gap(48)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VersoContent extends StatelessWidget {
  const VersoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 700,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Placeholder(),
                const Gap(24),
                ProjectText(Project.verso.copy),
                const Gap(24),
                const LinkButton(Link.versoDesignCaseStudy)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForceDirectedGraph extends StatelessWidget {
  const ForceDirectedGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContentContainer(
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: 400,
            height: 600,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Reprovider<HomeViewModel, ForceDirectedGraphViewModel>(
              selector: (vm) => vm.forceDirectedGraph,
              child: const ForceDirectedGraphDemo(),
            ),
          ),
          const Gap(30),
          ProjectText(Project.forceDirectedGraph.copy),
          const Gap(24),
          const LinkButton(Link.forceDirectedGraphGithub)
        ],
      ),
    );
  }
}

class MotionBlurContent extends StatelessWidget {
  const MotionBlurContent({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContentContainer(
      child: Column(children: [
        Reprovider<HomeViewModel, MotionBlurViewModel>(
            selector: (vm) => vm.motionBlur, child: const MotionBlurDemo()),
        const Gap(24),
        ProjectText(Project.motionBlur.copy),
        const Gap(24),
        const LinkButton(Link.motionBlurGithub),
      ]),
    );
  }
}

class _ContentContainer extends StatelessWidget {
  const _ContentContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 700,
          child: Padding(padding: const EdgeInsets.all(24.0), child: child),
        ),
      ),
    );
  }
}

class ProjectText extends StatelessWidget {
  const ProjectText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton(this.link, {super.key});
  final Link link;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => launchUrl(link.url),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 45),
        elevation: 2,
      ),
      child: Text(
        link.text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
