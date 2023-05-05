import '../../main.dart';
export 'destination.dart';
export 'destinations.dart';

class DestinationSelector extends StatefulWidget {
  const DestinationSelector({Key? key}) : super(key: key);

  @override
  State<DestinationSelector> createState() => _DestinationSelectorState();
}

class _DestinationSelectorState extends State<DestinationSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _originAnimation;
  late Destination _destination;
  var _initialBuild = true;

  @override
  void didChangeDependencies() {
    final size = context.windowSize;
    final destination = Destination.of(context);
    if (_initialBuild) {
      _destination = destination;
      _controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      _controller.addListener((() => setState(() {})));
      _scaleAnim = _controller.drive<double>(Tween<double>(
        begin: _destination.getScale(size),
        end: _destination.getScale(size),
      ));
      _originAnimation = _controller.drive(
          Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0)));
      _initialBuild = false;
    } else {
      goTo(destination, context.windowSize);
    }

    super.didChangeDependencies();
  }

  void goTo(Destination newDestination, Size size) {
    var curved = CurvedAnimation(
      parent: _controller,
      curve: newDestination == Destinations.home
          ? Curves.easeInOut
          : Curves.fastOutSlowIn,
    );

    final originCurve = CurvedAnimation(
        parent: _controller,
        curve: newDestination is ProjectDestination
            ? Curves.easeOutExpo
            : Curves.fastOutSlowIn);

    _scaleAnim = curved.drive<double>(Tween<double>(
      begin: _destination.getScale(size),
      end: newDestination.getScale(size),
    ));
    _originAnimation = originCurve.drive(Tween<Offset>(
      begin: _destination == Destinations.home
          ? newDestination.origin
          : _destination.origin,
      end: newDestination == Destinations.home
          ? _destination.origin
          : newDestination.origin,
    ));
    _controller.value = 0;
    _controller.forward();

    _destination = newDestination;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Transform.scale(
          scale: _scaleAnim.status == AnimationStatus.forward
              ? _scaleAnim.value
              : _destination.getScale(size),
          origin: _originAnimation.value,
          alignment: Alignment.topLeft,
          child: const HomePage(),
        ),
      ],
    );
  }
}
