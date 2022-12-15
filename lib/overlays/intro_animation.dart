import '../main.dart';

class IntroAnimation extends StatefulWidget {
  const IntroAnimation({super.key});

  @override
  State<IntroAnimation> createState() => _IntroAnimationState();
}

class _IntroAnimationState extends State<IntroAnimation> {
  double _scale = 10;
  var _animationCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (_scale == 10) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        _scale = 1;
        // await Future.delayed(const Duration(milliseconds: 900));
        rebuild();
      });
    }
    if (!_animationCompleted) {
      return Center(
        child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            onEnd: () => setState(() {
                  _animationCompleted = true;
                  context.appState.introAnimationCompleted.value = true;
                }),
            child: const LogoBackground(
              child: SizedBox(),
            )),
      );
    }
    return const SizedBox();
  }
}
