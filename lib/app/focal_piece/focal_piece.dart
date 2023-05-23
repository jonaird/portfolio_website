import 'package:website/main.dart';
import 'focal_piece_container.dart';
import 'focal_piece_content.dart';
import 'dart:ui' as ui;

enum FocalPieceStages { firstBuild, intro, fab, contact }

class FocalPieceViewModel extends EmitterContainer {
  final _stage = ValueEmitter(FocalPieceStages.firstBuild, keepHistory: true);
  final animating = ValueEmitter(true);
  final containerViewModel = FocalPieceContainerViewModel();
  final contentViewModel = FocalPieceContentViewModel();
  final key = GlobalKey();

  final previousFrames = <ui.Image>[];

  var _introSequenceCompleted = false;

  bool get introSequenceCompleted => _introSequenceCompleted;

  Color get backgroundColor {
    if (stage == FocalPieceStages.contact) {
      return Colors.black54;
    }

    return Colors.transparent;
  }

  bool get backgroundShouldIgnorePointer => stage != FocalPieceStages.contact;

  void acceptPreviousFrame(ui.Image frame) {
    if (previousFrames.length > 4) previousFrames.removeLast();
    previousFrames.insert(0, frame);
  }

  void finishedAnimating() {
    if (stage == FocalPieceStages.intro) {
      stage = FocalPieceStages.fab;
    } else {
      animating.value = false;
    }
    if (stage == FocalPieceStages.fab && !animating.value) {
      _introSequenceCompleted = true;
    }
  }

  set stage(FocalPieceStages newStage) {
    if (newStage != _stage.value) {
      _stage.value = newStage;
      animating.value = true;
    }
  }

  FocalPieceStages get stage => _stage.value;
  FocalPieceStages? get previousStage => _stage.previous;

  Alignment get alignment {
    if (stage == FocalPieceStages.firstBuild ||
        stage == FocalPieceStages.intro ||
        stage == FocalPieceStages.contact) {
      return Alignment.center;
    }
    return Alignment.bottomRight;
  }

  Duration get animationDuration {
    if (stage == FocalPieceStages.firstBuild) {
      return const Duration(milliseconds: 0);
    }
    if (introSequenceCompleted) return const Duration(milliseconds: 300);
    return const Duration(milliseconds: 500);
  }

  static const fabScale = 1.6;
  static const animationCurve = Curves.easeInOutExpo;

  @override
  get children => {
        _stage,
        animating,
        containerViewModel,
        contentViewModel,
      };

  @override
  get dependencies => {_stage, animating};
}

class FocalPiece extends StatelessWidget {
  const FocalPiece({super.key});

  // @override
  // build(context) {
  //   return const Center(child: SampledText(text: 'hello', value: 30));
  // }
  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, shader, child) {
      final animating = context
          .select<FocalPieceViewModel, bool>((vm) => vm.animating.value)!;
      return AnimatedSampler(
        enabled: animating,
        (image, size, canvas) {
          final prevFrames =
              context.read<FocalPieceViewModel>()!.previousFrames;
          final prevFrame0 = prevFrames.isEmpty ? image : prevFrames.first;
          final prevFrame1 = prevFrames.length > 1 ? prevFrames[1] : image;
          // shader.setFloat(0, value);
          // shader.setFloat(1, value);
          shader.setFloat(0, size.width);
          shader.setFloat(1, size.height);
          shader.setImageSampler(0, image);
          shader.setImageSampler(1, prevFrame0);
          shader.setImageSampler(2, prevFrame1);

          canvas.drawRect(
            Offset.zero & size,
            Paint()..shader = shader,
          );
        },
        child: const _ShaderChild(),
      );
    }, assetKey: 'shaders/motion_blur.glsl');
  }
  // @override
  // Widget build(BuildContext context) {
  //   return ShaderBuilder(
  //     assetKey: 'shaders/motion_blur.glsl',
  //     (_, shader, child) {
  //       return AnimatedSampler(
  //         (image, size, canvas) {
  //           final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  //           shader
  //             ..setFloat(0, image.width.toDouble() / devicePixelRatio)
  //             ..setFloat(1, image.height.toDouble() / devicePixelRatio)
  //             ..setFloat(2, 0)
  //             ..setImageSampler(0, image);

  //           canvas
  //             ..save()
  //             ..drawRect(
  //               Offset.zero & size,
  //               Paint()..shader = shader,
  //             )
  //             ..restore();
  //         },
  //         child: const _ShaderChild(),
  //       );
  //     },
  //   );
  // }
}

class _ShaderChild extends ConsumerStatelessWidget<FocalPieceViewModel> {
  const _ShaderChild();

  @override
  Widget consume(_, vm) {
    return RepaintBoundary(
      key: vm.key,
      child: AnimatedAlign(
        alignment: vm.alignment,
        duration: vm.animationDuration,
        curve: FocalPieceViewModel.animationCurve,
        child: FittedBox(
          fit: BoxFit.none,
          child: Reprovider(
            selector: (FocalPieceViewModel vm) => vm.containerViewModel,
            child: const FocalPieceContainer(),
          ),
        ),
      ),
    );
  }
}

class FocalPieceBackground
    extends ConsumerStatelessWidget<FocalPieceViewModel> {
  const FocalPieceBackground({super.key});

  @override
  Widget consume(_, vm) {
    return IgnorePointer(
      ignoring: vm.backgroundShouldIgnorePointer,
      child: GestureDetector(
        onTap: vm.contentViewModel.onCloseContactCard,
        child: AnimatedContainer(
          duration: vm.animationDuration,
          color: vm.backgroundColor,
        ),
      ),
    );
  }
}
