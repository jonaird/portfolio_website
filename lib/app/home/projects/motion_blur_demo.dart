import 'package:website/main.dart';
import 'dart:math';
import 'package:motion_blur/motion_blur.dart';

class MotionBlurViewModel extends EmitterContainer {
  final started = ValueEmitter(false);
  final blurEnabled = ValueEmitter(false);
  var _controllerValue = 0.0;

  AnimationController requestNewController(
      SingleTickerProviderStateMixin tickerProvider) {
    final controller = AnimationController(
        vsync: tickerProvider,
        duration: const Duration(milliseconds: 700),
        value: _controllerValue);
    controller.addListener(() => _controllerValue = controller.value);
    return controller;
  }

  @override
  get children => {started, blurEnabled};
}

class MotionBlurDemo extends StatelessWidget {
  const MotionBlurDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Card(
          color: Colors.white,
          child: TryMeButton(
            child: Padding(
              padding: EdgeInsets.only(top: 300),
              child: SizedBox(
                width: 400,
                height: 150,
                child: Center(
                  child: _MovingCircle(),
                ),
              ),
            ),
          ),
        ),
        Gap(24),
        _MBSwitch()
      ],
    );
  }
}

class TryMeButton
    extends StatelessWidgetReprovider<MotionBlurViewModel, ValueEmitter<bool>> {
  const TryMeButton({super.key, required this.child});
  final Widget child;

  @override
  select(vm) => vm.started;

  @override
  Widget reprovide(BuildContext context, started) {
    return Stack(
      children: [
        child,
        if (!started.value)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 200),
            child: ElevatedButton(
                onPressed: () => started.value = true,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400),
                child: const Text('Try Me')),
          )
      ],
    );
  }
}

class _MovingCircle extends StatefulWidget {
  const _MovingCircle();

  @override
  State<_MovingCircle> createState() => __MovingCircleState();
}

class __MovingCircleState extends State<_MovingCircle>
    with SingleTickerProviderStateMixin {
  late final _controller =
      context.read<MotionBlurViewModel>()!.requestNewController(this);

  @override
  void initState() {
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.value = 0.02;
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (context.select<MotionBlurViewModel, bool>((vm) => vm.started.value)!) {
      _controller.forward();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const width = 50.0;
    return Transform.translate(
      offset: Offset(sin(_controller.value * 2 * pi) * 150,
          cos(_controller.value * 2 * pi) * 150 - 150),
      child: MotionBlur(
        enabled: context.depend<MotionBlurViewModel>()!.blurEnabled.value,
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
    );
  }
}

class _MBSwitch
    extends StatelessWidgetReprovider<MotionBlurViewModel, ValueEmitter<bool>> {
  const _MBSwitch();

  @override
  ValueEmitter<bool> select(MotionBlurViewModel vm) => vm.blurEnabled;

  @override
  Widget reprovide(BuildContext contex, blurEnabled) {
    return Column(
      children: [
        Text('Motion blur: ${blurEnabled.value ? 'enabled' : 'disabled'}'),
        Switch(
          value: blurEnabled.value,
          onChanged: (value) => blurEnabled.value = value,
        )
      ],
    );
  }
}
