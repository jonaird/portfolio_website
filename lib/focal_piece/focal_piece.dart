import 'package:website/main.dart';
import 'focal_piece_background.dart';
import 'focal_piece_content.dart';

enum FocalPieceStages { firstBuild, intro, fab, contact }

class FocalPieceViewModel extends EmitterContainer {
  final _stage = ValueEmitter(FocalPieceStages.firstBuild, keepHistory: true);
  final animating = ValueEmitter(true);
  final backgroundViewModel = FocalPieceBackgroundViewModel();
  final contentViewModel = FocalPieceContentViewModel();
  var _introSequenceCompleted = false;

  bool get introSequenceCompleted => _introSequenceCompleted;

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
    if (introSequenceCompleted) return const Duration(milliseconds: 250);
    return const Duration(milliseconds: 500);
  }

  static const fabScale = 1.6;
  // static const animationDuration = Duration(milliseconds: 500);
  static const animationCurve = Curves.easeInOutExpo;

  @override
  get children => {_stage, animating, backgroundViewModel, contentViewModel};

  @override
  get dependencies => {_stage, animating};
}

class FocalPiece extends ConsumerStatelessWidget<FocalPieceViewModel> {
  const FocalPiece({super.key});

  @override
  Widget consume(_, vm) {
    return AnimatedContainer(
      alignment: vm.alignment,
      duration: vm.animationDuration,
      curve: FocalPieceViewModel.animationCurve,
      child: FittedBox(
        fit: BoxFit.none,
        child: Reprovider(
          selector: (FocalPieceViewModel vm) => vm.backgroundViewModel,
          child: const FocalPieceBackground(),
        ),
      ),
    );
  }
}
