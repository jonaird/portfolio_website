import 'package:website/force_directed_graph.dart';
import 'package:website/main.dart';
import 'dart:math';
import 'package:motion_blur/motion_blur.dart';

const _text = '''
BSV News was a hacker news clone with a unique cryptocurrency integration. Instead of upvoting, users tipped small amounts of cryptocurrency allowing posters to earn money for their contributions. The tip total was then used as a metric to rank posts on the home page.

BSV News used a novel architecture that took advantage of the low transaction fees and instant confirmations of the BSV cryptocurrency network. Instead of creating an account and authenticating on a private backend server, users broadcast their actions to the BSV mining network using a custom data encoding protocol. On the backend, these transactions were streamed from the blockchain in real time using an intermediary. These transactions were used to update persistent state in a MongoDB instance

This architecture allowed any 3rd party to be able to permissionlessly recreate the current state of BSV News and offer a competing frontend to the protocol.
''';

class BsvNews extends StatelessWidget {
  const BsvNews({super.key});

  @override
  Widget build(BuildContext context) {
    return ProjectContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                _text,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Gap(24),
            const Expanded(
              flex: 1,
              child: Column(
                children: [Placeholder(), Gap(12), Placeholder()],
              ),
            )
          ],
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
    return ProjectContainer(
      child: Container(
        width: 900,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 650,
          child: ListView(
            children: [
              const Gap(24),
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/OST.png',
                  fit: BoxFit.contain,
                  width: 650,
                ),
              ),
              const Gap(24),
              const SizedBox(
                width: 700,
                child: Text(_changeEmitterText),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text("View on Github")),
                  const Gap(12),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Read the Design Doc'),
                  ),
                ],
              ),
              const Gap(24)
            ],
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
    return ProjectContainer(
      child: Column(
        children: [
          const Gap(24),
          const Row(children: [
            Expanded(child: Text(_versoText)),
            Gap(24),
            Expanded(child: Placeholder()),
          ]),
          const Gap(24),
          ElevatedButton(
              onPressed: () {}, child: const Text('Read the Case Study'))
        ],
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
    return ProjectContainer(
      child: Row(children: [
        const Expanded(child: Text(_forceDirectedGraphText)),
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
    return const ProjectContainer(
      child: Column(children: [
        Row(
          children: [
            Expanded(child: Text(_motionBlurText)),
            Expanded(
              child: MotionBlurDemo(),
            )
          ],
        ),
      ]),
    );
  }
}

class MotionBlurDemo extends StatefulWidget {
  const MotionBlurDemo({super.key});

  @override
  State<MotionBlurDemo> createState() => _MotionBlurDemoState();
}

class _MotionBlurDemoState extends State<MotionBlurDemo>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  var _enabled = false;

  @override
  void initState() {
    _controller.addListener(() => setState(() {}));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.value = 0.02;
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final width = 40 * (sin(_controller.value * 2 * pi) + 1) + 15;
    const width = 50.0;
    return Column(
      children: [
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 300),
            child: SizedBox(
              width: 400,
              height: 150,
              child: Center(
                child: Transform.translate(
                  offset: Offset(sin(_controller.value * 2 * pi) * 150,
                      cos(_controller.value * 2 * pi) * 150 - 150),
                  child: MotionBlur(
                    enabled: _enabled,
                    intensity: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Container(
                        width: width,
                        height: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width / 2),
                            color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(24),
        Text('Motion blur: ${_enabled ? 'enabled' : 'disabled'}'),
        Switch(
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        )
      ],
    );
  }
}
