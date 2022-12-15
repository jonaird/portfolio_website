import "package:website/main.dart";

class ProjectsPageContent extends StatelessWidget {
  const ProjectsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Project(Destinations.bsvNews),
        const Gap(20),
        Project(Destinations.verso),
        // Gap(20),
        // Project("graph thing"),
        // Gap(20),
        // Project("Verso"),
        const Gap(20),
      ],
    );
  }
}

class Project extends StatelessWidget {
  const Project(this.destination, {super.key});
  final ProjectDestination destination;

  @override
  Widget build(BuildContext context) {
    final useKey =
        context.findAncestorStateOfType<ScrollOverlayState>() == null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(destination.title),
        Portal(key: useKey ? destination.key : null)
      ],
    );
  }
}

class Portal extends StatefulWidget {
  const Portal({super.key});

  @override
  State<Portal> createState() => _PortalState();
}

class _PortalState extends State<Portal> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: UniqueKey(),
        onTap: () => context.appState.destination.value = Destinations.bsvNews,
        child: Container(
          width: 100 * context.windowSize.width / context.windowSize.height,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 5),
              color: Colors.grey),
        ),
      ),
    );
  }
}
