import 'package:website/main.dart';
import 'focal_piece_content.dart';

class FocalPieceContainerViewModel extends EmitterContainer {
  @override
  FocalPieceViewModel get parent => super.parent as FocalPieceViewModel;
  late final _parameters = ValueEmitter.reactive(
    reactTo: [parent],
    withValue: () => _getParameters,
    keepHistory: true,
  );

  ContainerParameters get parameters => _parameters.value;

  void finishedAnimating() => parent.finishedAnimating();

  void onFirstBuild() async {
    await Future.delayed(const Duration(milliseconds: 500));
    parent.stage = FocalPieceStages.intro;
  }

  bool get firstBuild => parent.stage == FocalPieceStages.firstBuild;

  void handleFABTap() {
    parent.stage = FocalPieceStages.contact;
  }

  Duration get animationDuration => parent.animationDuration;

  final _boxShadow = kElevationToShadow[2];

  double get focalPieceDimmerOpacity {
    if (parent.stage == FocalPieceStages.contact) return 0.2128;
    return 0;
  }

  ContainerParameters get _getParameters {
    switch (parent.stage) {
      case FocalPieceStages.firstBuild:
        return ContainerParameters(
          width: 2000,
          height: 2000,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000), boxShadow: _boxShadow),
        );
      case FocalPieceStages.intro:
        return ContainerParameters(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150), boxShadow: _boxShadow),
        );
      case FocalPieceStages.fab:
        return ContainerParameters(
          width: 56 * FocalPieceViewModel.fabScale,
          height: 56 * FocalPieceViewModel.fabScale,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(28 * FocalPieceViewModel.fabScale),
              boxShadow: _boxShadow),
        );
      case FocalPieceStages.contact:
        return ContainerParameters(
          width: 450,
          height: 200,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(6 * FocalPieceViewModel.fabScale),
              boxShadow: _boxShadow),
        );
    }
  }

  @override
  get dependencies => {_parameters};
}

class ContainerParameters {
  const ContainerParameters(
      {required this.width, required this.height, required this.decoration});
  final double width;
  final double height;
  final BoxDecoration decoration;

  @override
  bool operator ==(Object other) =>
      other is ContainerParameters &&
      other.width == width &&
      other.height == height &&
      other.decoration == decoration;

  @override
  int get hashCode => Object.hash(width, height, decoration);
}

class FocalPieceContainer extends StatefulWidget {
  const FocalPieceContainer({super.key});

  @override
  State<FocalPieceContainer> createState() => _FocalPieceContainerState();
}

class _FocalPieceContainerState
    extends ConsumerState<FocalPieceContainer, FocalPieceContainerViewModel> {
  var initialBuild = true;
  @override
  Widget consume(context, fp) {
    if (fp.firstBuild) fp.onFirstBuild();
    return Padding(
      padding: const EdgeInsets.all(16.0 * 3),
      child: AnimatedContainer(
        width: fp.parameters.width,
        height: fp.parameters.height,
        curve: FocalPieceViewModel.animationCurve,
        duration: fp.animationDuration,
        onEnd: fp.finishedAnimating,
        decoration: fp.parameters.decoration,
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Theme.of(context).primaryColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
