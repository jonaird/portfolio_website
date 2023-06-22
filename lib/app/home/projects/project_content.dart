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

const _text = '''
BSV News was a hacker news clone with a unique cryptocurrency integration. Instead of upvoting, users tipped small amounts of cryptocurrency allowing posters to earn money for their contributions. The tip total was then used as a metric to rank posts on the home page.

BSV News used a novel architecture that took advantage of the low transaction fees and instant confirmations of the BSV cryptocurrency network. Instead of creating an account and authenticating on a private backend server, users broadcast their actions to the BSV mining network using a custom data encoding protocol. On the backend, these transactions were streamed from the blockchain in real time using an intermediary. These transactions were used to update persistent state in a MongoDB instance

This architecture allowed any 3rd party to be able to permissionlessly recreate the current state of BSV News and offer a competing frontend to the protocol.
''';

class BsvNews extends StatelessWidget {
  const BsvNews({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: SizedBox(
            width: 900,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ProjectText(
                    _text,
                  ),
                ),
                Gap(24),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Placeholder(fallbackHeight: 200),
                      Gap(12),
                      Placeholder(fallbackHeight: 200)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _changeEmitterText = '''
When developing BSV News, I found that the available state management solutions did not capture the same simplicity and elegance of the Flutter framework itself and so I decided to develop my own.

After some experimentation, I settled on an architecture I call Observable State Trees. I found that this architecture made my codebases very easy to understand, navigate, and change with very minimal boilerplate code.

change_emitter is a library for Flutter designed around implementing OSTs. Rather than an opaque framework, change_emitter provides a set of simple, easy to understand, and interoperable components allowing for a great degree of flexibility in implementation.
''';

class ChangeEmitterContent extends StatelessWidget {
  const ChangeEmitterContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isOverlay =
        context.findAncestorWidgetOfExactType<ProjectContentOverlay>() != null;

    return SingleChildScrollView(
      controller: isOverlay
          ? Project.changeEmitter.controllers.overlayController
          : Project.changeEmitter.controllers.baseController,
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
                const ProjectText(_changeEmitterText),
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

const _versoText = '''
Verso, my startup’s product offering, was an interconnected knowledge marketplace. It used the power of instantaneous internet micropayments and a novel content format to enable a new kind of experience for publishing and consuming knowledge. Rather than publishing articles, a format that has hardly changed in hundreds of years, users could publish short posts on individual concepts and link these posts together to form a web of knowledge and earn money for doing so.
''';

class VersoContent extends StatelessWidget {
  const VersoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 900,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(children: [
                  Expanded(child: ProjectText(_versoText)),
                  Gap(24),
                  Expanded(child: Placeholder()),
                ]),
                Gap(24),
                LinkButton(Link.versoDesignCaseStudy)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _forceDirectedGraphText = '''
force directed graph
''';

class ForceDirectedGraph extends StatelessWidget {
  const ForceDirectedGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContentContainer(
      child: Column(
        children: [
          Row(children: [
            const Expanded(child: ProjectText(_forceDirectedGraphText)),
            Expanded(
                child: Container(
              clipBehavior: Clip.antiAlias,
              width: 300,
              height: 500,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: const ForceDirectedGraphDemo(),
            )),
          ]),
          const Gap(30),
          const LinkButton(Link.forceDirectedGraphGithub)
        ],
      ),
    );
  }
}

const _motionBlurText = '''
Flutter’s recent support for fragment shaders gives developers a huge new set of possibilities for immersive experiences in apps. motion_blur is a Flutter package that uses shaders to add motion blur to any moving widget. Simply add the motion_blur package to your project and wrap your moving widget in a MotionBlur widget and like magic, there’s motion blur!
''';

class MotionBlurContent extends StatelessWidget {
  const MotionBlurContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ContentContainer(
      child: Column(children: [
        Row(
          children: [
            Expanded(child: ProjectText(_motionBlurText)),
            Gap(24),
            Expanded(
              child: MotionBlurDemo(),
            )
          ],
        ),
        Gap(30),
        LinkButton(Link.motionBlurGithub),
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
          width: 900,
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
