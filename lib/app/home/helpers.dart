import 'package:website/main.dart';
import 'dart:ui';

class AppBlur
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<double>> {
  const AppBlur({super.key, required this.child});
  final Widget child;

  @override
  ValueEmitter<double> select(vm) => vm.blurAmount;

  @override
  Widget reprovide(BuildContext context, blurAmount) {
    return AnimatedBlur(
      blur: blurAmount.value,
      curve: FocalPieceViewModel.animationCurve,
      child: child,
    );
  }
}

class AnimatedBlur extends ImplicitlyAnimatedWidget {
  const AnimatedBlur({
    super.key,
    required this.child,
    super.curve,
    super.duration = const Duration(milliseconds: 400),
    super.onEnd,
    required this.blur,
  });
  final Widget child;
  final double blur;

  @override
  AnimatedWidgetBaseState<AnimatedBlur> createState() => _AnimatedBlurState();
}

class _AnimatedBlurState extends AnimatedWidgetBaseState<AnimatedBlur> {
  Tween<double>? _blurValue;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _blurValue = visitor(_blurValue, widget.blur,
        (value) => Tween<double>(begin: value as double)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _blurValue!.evaluate(animation),
              sigmaY: _blurValue!.evaluate(animation),
              // sigmaX: 4.0,
              // sigmaY: 4.0,
            ),
            child: Container(),
          ),
        ),
      ],
    );
  }
}

class ScaffoldCapture extends StatelessWidget {
  const ScaffoldCapture({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    context
        .read<AppViewModel>()!
        .captureScaffoldMessanger(ScaffoldMessenger.of(context));
    return child;
  }
}

class ProjectContentOverlay
    extends StatelessWidgetReprovider<AppViewModel, ProjectSelectorViewModel> {
  const ProjectContentOverlay({super.key});

  @override
  ProjectSelectorViewModel select(AppViewModel vm) {
    return vm.projectSelector;
  }

  @override
  Widget reprovide(BuildContext context, vm) {
    if (vm.showProjectContentOverlay.value) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: vm.selectedProject.value!.content,
      );
    }
    return const SizedBox();
  }
}

class HomeHider
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<bool>> {
  const HomeHider({super.key, required this.child});
  final Widget child;
  @override
  ValueEmitter<bool> select(HomeViewModel vm) => vm.showHome;
  @override
  Widget reprovide(BuildContext context, showHome) {
    if (!showHome.value) return const SizedBox();
    return child;
  }
}

class ThemeSwitcher
    extends StatelessWidgetReprovider<AppViewModel, ValueEmitter<Brightness>> {
  const ThemeSwitcher({
    super.key,
  });

  @override
  select(appViewModel) => appViewModel.theme;

  @override
  Widget reprovide(BuildContext context, theme) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
        child: IconButton(
          onPressed: theme.toggle,
          icon: Icon(
            switch (theme.value) {
              Brightness.light => Icons.dark_mode_outlined,
              Brightness.dark => Icons.light_mode_outlined
            },
          ),
        ),
      ),
    );
  }
}
