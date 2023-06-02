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
      parent.stage = FocalPieceStages.intro;
    });
  }

  bool get firstBuild => parent.stage == FocalPieceStages.firstBuild;

  void handleFABTap() {
    parent.stage = FocalPieceStages.contact;
  }

  Duration get animationDuration => parent.animationDuration;

  double get focalPieceDimmerOpacity {
    if (parent.stage == FocalPieceStages.contact) return 0.2128;
    return 0;
  }

  @override
  get dependencies => {_parameters};
}

typedef ContainerParameters = ({
  num width,
  num height,
  BoxDecoration decoration
});

class FocalPieceContainer extends StatefulWidget {
  const FocalPieceContainer({super.key});

  @override
  State<FocalPieceContainer> createState() => _FocalPieceContainerState();
}

class _FocalPieceContainerState
    extends ConsumerState<FocalPieceContainer, FocalPieceContainerViewModel> {
  @override
  Widget consume(context, fp) {
    if (fp.firstBuild) fp.onFirstBuild();
    return Padding(
      padding: const EdgeInsets.all(16.0 * 3),
      child: AnimatedContainer(
        width: fp.parameters.width.toDouble(),
        height: fp.parameters.height.toDouble(),
        curve: FocalPieceViewModel.animationCurve,
        duration: fp.animationDuration,
        onEnd: fp.finishedAnimating,
        decoration: fp.parameters.decoration,
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Theme.of(context).colorScheme.secondary,
          child: Stack(
            children: [
              IgnorePointer(
                child: AnimatedOpacity(
                  opacity: fp.focalPieceDimmerOpacity,
                  duration: fp.animationDuration,
                  child: Container(color: Colors.black),
                ),
              ),
              Reprovider(
                selector: (FocalPieceViewModel vm) => vm.contentViewModel,
                child: const FocalPieceContent(),
              ),
              // const AnimationFrameRetriever()
            ],
          ),
        ),
      ),
    );
  }
}
