import 'package:website/main.dart';
import 'focal_piece_content.dart';

class FocalPieceContainerViewModel extends EmitterContainer {
  @override
  FocalPieceViewModel get parent => super.parent as FocalPieceViewModel;
  late final _parameters = ValueEmitter.reactive(
    reactTo: [parent],
    withValue: () => parent.stage.parameters,
    keepHistory: true,
  );

  ContainerParameters get parameters => _parameters.value;

  Alignment get alignment {
    if (parent.stage == FocalPieceStages.fab) return Alignment.bottomRight;
    return Alignment.center;
  }

  void finishedAnimating() => parent.finishedAnimating();

  void onFirstBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 200), () {
        parent.stage = FocalPieceStages.intro;
      });
    });
  }

  bool get firstBuild => parent.stage == FocalPieceStages.firstBuild;

  void handleFABTap() {
    parent.stage = FocalPieceStages.contact;
  }

  Duration get animationDuration => parent.animationDuration;

  @override
  get dependencies => {_parameters};
}

class FocalPieceContainer
    extends StatelessWidgetConsumer<FocalPieceContainerViewModel> {
  const FocalPieceContainer({super.key});

  @override
  Widget consume(context, fp) {
    if (fp.firstBuild) fp.onFirstBuild();

    return AnimatedContainer(
      width:
          fp.parameters.width?.toDouble() ?? MediaQuery.of(context).size.width,
      height: fp.parameters.height?.toDouble() ??
          MediaQuery.of(context).size.height,
      curve: FocalPieceViewModel.animationCurve,
      duration: fp.animationDuration,
      onEnd: fp.finishedAnimating,
      decoration: fp.parameters.decoration,
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        elevation: 2,
        child: Reprovider(
          selector: (FocalPieceViewModel vm) => vm.content,
          child: const FocalPieceContent(),
        ),
      ),
    );
  }
}
