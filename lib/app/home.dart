import 'package:website/main.dart';

const _textColor = Color(0xFFCFD8DC);

class HomePage extends ConsumerStatelessWidget<AppViewModel> {
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
          height: context.windowSize.height + 1000,
          child: ListView(
            physics: vm.destination.value == Destinations.home
                ? null
                : const NeverScrollableScrollPhysics(),
            children: const [
              Gap(500),
              Bio(),
              Gap(48),
              Projects(),
              Gap(648),
            ],
          ),
        ),
      ),
    );
  }
}

const _bioText =
    "I’m from Chicago but I live in Hungary with my wife and 2 year old son. I’m a full stack developer, Flutter specialist and product designer. In 2018 I dropped out of a math degree at Roosevelt University to persue a startup at the intersection of cryptocurrency and social media. I taught myself how to code, graduated from the Founder Institute, raised a venture funding round, hired a developer and released a product to market. Unfortunately, due to extenuating circumstances, I had to shut the company down in July 2022. After taking a much-needed sabbatical, I’m excited to reenter the workforce!";

class Bio extends StatelessWidget {
  const Bio({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 730,
        child: Column(
          children: [
            const Gap(80),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hi! My name is\nJonathan Aird \nand I build apps',
                  style: TextStyle(fontSize: 60, color: _textColor),
                ),
                const Gap(24),
                Container(width: 225, height: 225, color: Colors.grey),
              ],
            ),
            const Gap(24),
            const Text(
              _bioText,
              style: TextStyle(color: _textColor, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class Projects extends StatelessWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Projects',
          style: TextStyle(fontSize: 60, color: _textColor),
        ),
        const Gap(48),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            Project(Destinations.bsvNews),
            Project(Destinations.changeEmitter),
            Project(Destinations.verso),
          ],
        )
      ],
    );
  }
}

class Project extends ConsumerStatelessWidget<AppViewModel> {
  const Project(this.project, {super.key});
  final ProjectDestination project;

  @override
  Widget consume(BuildContext context, vm) {
    return AnimatedOpacity(
      opacity: vm.destination.value == project ? 0 : 1,
      duration: const Duration(milliseconds: 400),
      child: ProjectCard(project),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard(this.project, {super.key});
  final ProjectDestination project;

  final _borderRadius = 11.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: project.key,
      elevation: 5,
      color: const Color(0xFF455A64),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius)),
      child: Material(
        color: const Color(0xFF455A64),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius)),
        child: InkWell(
          onTap: () => context.appViewModel.selectProject(project),
          borderRadius: BorderRadius.circular(_borderRadius),
          child: SizedBox(
            width: 330,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(color: _textColor, fontSize: 36),
                  ),
                  Text(
                    project.subtitle,
                    style: const TextStyle(color: _textColor, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
