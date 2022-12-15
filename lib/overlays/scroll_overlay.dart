import 'overlays.dart';

class ScrollOverlay extends StatefulWidget {
  const ScrollOverlay({
    required this.destination,
    required this.onScroll,
    super.key,
  });
  final PageDestination destination;
  final void Function(double) onScroll;

  @override
  State<ScrollOverlay> createState() => ScrollOverlayState();
}

class ScrollOverlayState extends State<ScrollOverlay> {
  final controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      widget.onScroll(controller.offset);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Opacity(opacity: 0, child: widget.destination.widget),
      ),
    );
  }
}
