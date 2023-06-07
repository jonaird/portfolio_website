import 'package:website/main.dart';

const _textColor = Color(0xFFCFD8DC);

class Projects extends StatelessWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Projects',
          style: Theme.of(context).textTheme.displayLarge,
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

class Project extends StatelessWidgetConsumer<AppViewModel> {
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

  final _borderRadius = 9.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: project.key,
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius)),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
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
                  Text(project.title,
                      // style: const TextStyle(color: _textColor, fontSize: 36),
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    project.subtitle,
                    style: Theme.of(context).textTheme.headlineSmall,
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
