import 'package:website/main.dart';

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

class ScaffoldCapture extends StatelessWidget {
  const ScaffoldCapture({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    context
        .read<AppViewModel>()!
        .setScaffoldMessanger(ScaffoldMessenger.of(context));
    return child;
  }
}

class ProjectContentOverlay extends StatelessWidgetConsumer<AppViewModel> {
  const ProjectContentOverlay({super.key});

  @override
  Widget consume(BuildContext context, vm) {
    if (!vm.animating.value && vm.selectedProject.isNotNull) {
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
