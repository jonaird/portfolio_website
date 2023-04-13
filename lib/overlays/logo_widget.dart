import 'overlays.dart';

class LogoWidget extends StatefulWidget {
  const LogoWidget({super.key});

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> {
  final _duration = const Duration(milliseconds: 450);
  final _curve = Curves.easeInOutExpo;
  bool _leftHome = false;

  @override
  Widget build(BuildContext context) {
    final destination = Destination.of(context);
    if (destination != Destinations.home) _leftHome = true;

    final child = Center(
      child: AnimatedCrossFade(
        duration: _leftHome ? _duration : Duration.zero,
        firstCurve: _curve,
        secondCurve: _curve,
        sizeCurve: _curve,
        firstChild: Image.memory(logoBytes),
        secondChild: const Icon(
          Icons.arrow_back,
          size: 200,
          color: Colors.white,
        ),
        crossFadeState: context.atHome
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
    return AnimatedPositioned(
      right: context.atHome ? context.windowSize.width / 2 - 150 : 0,
      bottom: context.atHome ? context.windowSize.height / 2 - 150 : 0,
      duration: _duration,
      curve: _curve,
      child: AnimatedScale(
          scale: context.atHome ? 1 : 0.2,
          duration: _duration,
          curve: _curve,
          child: LogoBackground(
            onTap: context.appState.handleBackButton,
            child: child,
          )),
    );
  }
}

class LogoBackground extends StatelessWidget {
  const LogoBackground({
    super.key,
    required this.child,
    this.onTap,
  });
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(150),
          child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                color: Theme.of(context).primaryColor,
              ),
              child: child),
        ),
      ),
    );
  }
}
