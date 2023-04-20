import 'package:website/main.dart';

const _textColor = Color(0xFFCFD8DC);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView(
        children: const [
          Bio(),
          Gap(48),
          ProjectCards(),
          Gap(48),
        ],
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
                  'Hi! My name is\nJonathan Aird ',
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

class ProjectCards extends StatelessWidget {
  const ProjectCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Projects',
          style: TextStyle(fontSize: 60, color: _textColor),
        ),
        const Gap(48),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ProjectCard(project: Project.bsvNews),
            Gap(24),
            ProjectCard(project: Project.changeEmitter),
            Gap(24),
            ProjectCard(project: Project.verso),
          ],
        )
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, super.key});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF455A64),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}

enum Project {
  bsvNews("BSV News", "Fullstack Development"),
  changeEmitter("change_emitter", "Flutter Expertise"),
  verso("Verso", "Product Design");

  final String title;
  final String subtitle;

  const Project(this.title, this.subtitle);
}
