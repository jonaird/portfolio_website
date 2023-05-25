import 'package:website/main.dart';
import 'focal_piece_container.dart';
import 'focal_piece_content.dart';
export 'motion_blur.dart';

enum FocalPieceStages { firstBuild, intro, fab, contact }

class FocalPieceViewModel extends EmitterContainer {
  final _stage = ValueEmitter(FocalPieceStages.firstBuild, keepHistory: true);
  final animating = ValueEmitter(true);
  final containerViewModel = FocalPieceContainerViewModel();
  final contentViewModel = FocalPieceContentViewModel();

  var _introSequenceCompleted = false;

  bool get introSequenceCompleted => _introSequenceCompleted;

  Color get backgroundColor {
    if (stage == FocalPieceStages.contact) {
      return Colors.black54;
    }

    return Colors.transparent;
  }

  bool get backgroundShouldIgnorePointer => stage != FocalPieceStages.contact;

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

class FocalPiece extends ConsumerStatelessWidget<FocalPieceViewModel> {
  const FocalPiece({super.key});

  @override
  Widget consume(_, vm) {
    return AnimatedAlign(
      alignment: vm.alignment,
      duration: vm.animationDuration,
      curve: FocalPieceViewModel.animationCurve,
      child: FittedBox(
        fit: BoxFit.none,
        child: Reprovider(
          selector: (FocalPieceViewModel vm) => vm.containerViewModel,
          child: const MotionBlur(child: FocalPieceContainer()),
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
