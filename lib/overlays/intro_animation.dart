import '../main.dart';

class IntroAnimation extends StatefulWidget {
  const IntroAnimation({super.key});

  @override
  State<IntroAnimation> createState() => _IntroAnimationState();
}

class _IntroAnimationState extends State<IntroAnimation> {
  double _scale = 10;

  @override
  Widget build(BuildContext context) {
    if (_scale == 10) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await Future.delayed(const Duration(milliseconds: 500));
        _scale = 1;
        rebuild();
      });
    }
    return Center(
      child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          onEnd: () => context.appState.introAnimationCompleted.value = true,
          child: const LogoBackground(
            child: SizedBox(),
          )),
    );
  }
}
