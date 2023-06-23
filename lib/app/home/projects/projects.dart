import 'package:website/main.dart';
export 'project_content.dart';

enum Project {
  bsvNews(
    title: 'BSV News',
    subtitle: 'Fullstack Development',
    path: '/bsvNews',
    content: BsvNews(),
  ),

  changeEmitter(
    path: '/changeEmitter',
    title: 'change_emitter',
    subtitle: 'Flutter Expertise',
    content: ChangeEmitterContent(),
  ),

  verso(
    title: 'Verso',
    subtitle: 'Product Design',
    path: '/verso',
    content: VersoContent(),
  ),

  forceDirectedGraph(
    title: 'force_directed_graph',
    subtitle: 'Minimal & Powerful APIs',
    path: '/forceDirectedGraph',
    content: ForceDirectedGraph(),
  ),
  motionBlur(
    title: 'motion_blur',
    subtitle: 'The Power of Shaders',
    path: '/forceDirectedGraph',
    content: MotionBlurContent(),
  );

  const Project({
    required this.path,
    required this.title,
    required this.subtitle,
    required this.content,
  });
  final String path;
  final String title;
  final String subtitle;
  final Widget content;

  static final keys =
      Project.values.asMap().map((key, value) => MapEntry(value, GlobalKey()));

  GlobalKey get key => keys[this]!;

  static Project? fromUri(String uri) {
    final destList = List.from(values)
      ..retainWhere((element) => element.path == uri);
    if (destList.isEmpty) return null;
    return destList.first;
  }

  Offset get origin {
    var size = MediaQuery.of(key.currentContext!).size;
    size = Size(size.width, size.height - 56);
    final y = key.offset.dy +
        key.offset.dy / (size.height / key.projectCardSize.height - 1);
    final scaledWidth = (size.width * key.projectCardSize.height / size.height);
    final scaledOffsetX =
        key.offset.dx + (key.projectCardSize.width - scaledWidth) / 2;
    final x = scaledOffsetX +
        scaledOffsetX / (size.height / key.projectCardSize.height - 1);
    return Offset(x, y);
  }

  double get scale {
    //have to subtract the height of the app bar
    final height = MediaQuery.of(key.currentContext!).size.height - 56;
    return height / key.projectCardSize.height;
  }

  String get copy => projectCopy(this);
}

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Projects',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const Gap(48),
        SizedBox(
          width: 1200,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: Project.values.map((e) => ProjectDisplay(e)).toList(),
          ),
        )
      ],
    );
  }
}

class ProjectDisplay extends StatelessWidgetConsumer<ProjectSelectorViewModel> {
  const ProjectDisplay(this.project, {super.key});
  final Project project;

  @override
  Widget consume(BuildContext context, vm) {
    return SizedBox(
      width: 330,
      height: 200,
      child: Stack(
        children: [
          if (vm.showProjectContent(project))
            ProjectContainer(child: project.content),
          IgnorePointer(
            ignoring: vm.selectedProject.isNotNull,
            child: AnimatedOpacity(
              opacity: vm.selectedProject.isNotNull ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              child: ProjectCard(project),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard(this.project, {super.key});
  final Project project;

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
          onTap: () => context
              .read<ProjectSelectorViewModel>()!
              .selectedProject
              .value = project,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: SizedBox(
            width: 330,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(project.title,
                        // style: const TextStyle(color: _textColor, fontSize: 36),
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
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

class ProjectContainer extends StatelessWidget {
  const ProjectContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var width = 900.0;
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < width) width = screenWidth;
    var height = 200 * Project.bsvNews.scale;
    // final windowHeight = MediaQuery.of(context).size.height - 56;
    // if (windowHeight < height) height = windowHeight;

    return SizedBox(
      width: 330,
      height: 200,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: SizedBox(
          width: screenWidth,
          height: height,
          child: child,
        ),
      ),
    );
  }
}
