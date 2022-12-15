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

    final showBackground = context.select<AppState, bool>(
        (state) => state.introAnimationCompleted.value)!;
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
      // left: context.atHome ? context.windowSize.width / 2 - 150 : -100,
      // top: context.atHome ? context.windowSize.height / 2 - 150 : -100,
      left: context.atHome ? context.windowSize.width / 2 - 150 : -100,
      top: context.atHome ? context.windowSize.height / 2 - 150 : -115,
      duration: _duration,
      curve: _curve,
      child: AnimatedScale(
        scale: context.atHome ? 1 : 0.2,
        duration: _duration,
        curve: _curve,
        child: showBackground
            ? LogoBackground(
                onTap: context.appState.handleBackButton,
                child: child,
              )
            : SizedBox(width: 300, height: 300, child: child),
      ),
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
                color: const Color(0xFFFF7575),
              ),
              child: child),
        ),
      ),
    );
  }
}
