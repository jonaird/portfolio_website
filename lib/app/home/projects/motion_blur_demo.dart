import 'package:website/main.dart';
import 'dart:math';
import 'package:motion_blur/motion_blur.dart';

class MotionBlurDemo extends StatefulWidget {
  const MotionBlurDemo({super.key});

  @override
  State<MotionBlurDemo> createState() => _MotionBlurDemoState();
}

class _MotionBlurDemoState extends State<MotionBlurDemo>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  var _enabled = false;

  @override
  void initState() {
    _controller.addListener(() => setState(() {}));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.value = 0.02;
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final width = 40 * (sin(_controller.value * 2 * pi) + 1) + 15;
    const width = 50.0;
    return Column(
      children: [
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 300),
            child: SizedBox(
              width: 400,
              height: 150,
              child: Center(
                child: Transform.translate(
                  offset: Offset(sin(_controller.value * 2 * pi) * 150,
                      cos(_controller.value * 2 * pi) * 150 - 150),
                  child: MotionBlur(
                    enabled: _enabled,
                    intensity: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Container(
                        width: width,
                        height: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width / 2),
                            color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(24),
        Text('Motion blur: ${_enabled ? 'enabled' : 'disabled'}'),
        Switch(
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        )
      ],
    );
  }
}
