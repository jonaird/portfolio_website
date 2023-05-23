import 'package:flutter/rendering.dart';
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

  Alignment get alignment {
    if (parent.stage == FocalPieceStages.fab) return Alignment.bottomRight;
    return Alignment.center;
  }

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
    return switch (parent.stage) {
      FocalPieceStages.firstBuild => (
          width: 2000,
          height: 2000,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            boxShadow: _boxShadow,
          ),
        ),
      FocalPieceStages.intro => (
          width: 450,
          height: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(225),
            boxShadow: _boxShadow,
          ),
        ),
      FocalPieceStages.fab => (
          width: 56 * FocalPieceViewModel.fabScale,
          height: 56 * FocalPieceViewModel.fabScale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              28 * FocalPieceViewModel.fabScale,
            ),
            boxShadow: _boxShadow,
          ),
        ),
      FocalPieceStages.contact => (
          width: 450,
          height: 200,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(6 * FocalPieceViewModel.fabScale),
            boxShadow: _boxShadow,
          ),
        )
    };
  }

  @override
  get dependencies => {_parameters};
}

typedef ContainerParameters = ({
  double width,
  double height,
  BoxDecoration decoration
});

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
              const AnimationFrameRetriever()
            ],
          ),
        ),
      ),
    );
  }
}

class AnimationFrameRetriever extends StatefulWidget {
  const AnimationFrameRetriever({super.key});

  @override
  State<AnimationFrameRetriever> createState() =>
      _AnimationFrameRetrieverState();
}

class _AnimationFrameRetrieverState extends State<AnimationFrameRetriever> {
  late final Animation _animatedContainerController;

  bool _elementVisitor(Element element) {
    if (element is StatefulElement &&
        element.state.widget is AnimatedContainer) {
      debugPrint(element.state.toString());
      _animatedContainerController =
          ((element.state as ImplicitlyAnimatedWidgetState).animation
                  as CurvedAnimation)
              .parent;
      return false;
    }
    return true;
  }

  void _animationListener() async {
    final vm = context.read<FocalPieceViewModel>()!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      (vm.key.currentContext!.findRenderObject()! as RenderRepaintBoundary)
          .toImage(pixelRatio: 1)
          .then((value) => vm.acceptPreviousFrame(value));
    });
  }

  @override
  void initState() {
    context.visitAncestorElements(_elementVisitor);
    _animatedContainerController.addListener(_animationListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
