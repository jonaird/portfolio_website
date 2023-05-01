import "package:website/main.dart";
export 'force_directed_graph.dart';

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
        const Gap(20),
        Project(Destinations.changeEmitter)
      ],
    );
  }
}

class Project extends StatelessWidget {
  const Project(this.destination, {super.key});
  final ProjectDestination destination;

  @override
  Widget build(BuildContext context) {
    final useKey = Scrollable.of(context) == null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(destination.title),
        Portal(key: useKey ? destination.key : null, destination: destination)
      ],
    );
  }
}

class Portal extends StatelessWidget {
  const Portal({super.key, required this.destination});
  final ProjectDestination destination;

  @override
  Widget build(BuildContext context) {
    //whether the current widget is in the hidden scroll overlay or not.
    final includeContent = Scrollable.of(context) == null;
    final useButtonOverlay = context.select<AppViewModel, bool>(
        (appState) => appState.destination.value is! ProjectDestination)!;
    return Stack(
      children: [
        SizedBox(
          width: 100 * context.windowSize.width / context.windowSize.height,
          height: 100,
          child: Transform.scale(
            scale: scaleMultiple / destination.getScale(context.windowSize),
            child: OverflowBox(
              maxWidth: context.windowSize.width,
              maxHeight: context.windowSize.height,
              child: SizedBox(
                width: context.windowSize.width,
                height: context.windowSize.height,
                child: includeContent ? destination.content : null,
              ),
            ),
          ),
        ),
        if (useButtonOverlay)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              key: UniqueKey(),
              onTap: () {
                context.appViewModel.destination.value = destination;
              },
              child: SizedBox(
                width:
                    100 * context.windowSize.width / context.windowSize.height,
                height: 100,
                child: Center(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text('try me'),
                  onPressed: () {
                    context.appViewModel.destination.value = destination;
                  },
                )),
              ),
            ),
          ),
      ],
    );
  }
}
