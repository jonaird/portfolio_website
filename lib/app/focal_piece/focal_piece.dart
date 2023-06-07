import 'package:website/app/focal_piece/contact_card.dart';
import 'package:website/main.dart';
import 'focal_piece_container.dart';
import 'focal_piece_content.dart';
import 'package:motion_blur/motion_blur.dart';

class FocalPieceViewModel extends EmitterContainer {
  final _stage = ValueEmitter(FocalPieceStages.firstBuild, keepHistory: true);
  final animating = ValueEmitter(true);
  final container = FocalPieceContainerViewModel();
  final content = FocalPieceContentViewModel();
  final contactCard = ContactCardViewModel();

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

  void sendMessage() => contactCard.sendMessage();

  FocalPieceStages get stage => _stage.value;
  FocalPieceStages? get previousStage => _stage.previous;

  Alignment get alignment {
    if (stage == FocalPieceStages.fab) return Alignment.bottomRight;
    return Alignment.center;
  }

  Duration get animationDuration {
    if (stage == FocalPieceStages.firstBuild) {
      return const Duration(milliseconds: 0);
    }
    if (introSequenceCompleted) return const Duration(milliseconds: 350);
    return const Duration(milliseconds: 500);
  }

  Size get outerSize {
    if (stage == FocalPieceStages.contact && !animating.value) {
      return Size(stage.parameters.width.toDouble(),
          stage.parameters.height.toDouble());
    }
    final fab = FocalPieceStages.fab.parameters;
    return Size(fab.width + 3 * 16, fab.height + 3 * 16);
  }

  EdgeInsets get padding {
    if (introSequenceCompleted) {
      return const EdgeInsets.fromLTRB(290, 320, 0, 0);
    }
    return const EdgeInsets.all(0);
  }

  bool get motionBlurEnabled {
    return animating.value && introSequenceCompleted;
  }

  static const fabScale = 1.6;
  static const animationCurve = Curves.easeInOutExpo;

  @override
  get children => {
        _stage,
        animating,
        container,
        content,
        contactCard,
      };

  @override
  get dependencies => {_stage, animating};
}

final _boxShadow = kElevationToShadow[2];

enum FocalPieceStages {
  firstBuild,
  // renderApp,
  intro,
  fab,
  contact;

  ContainerParameters get parameters {
    return switch (this) {
      FocalPieceStages.firstBuild => (
          width: 2000.0,
          height: 2000.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            boxShadow: _boxShadow,
          ),
        ),
      FocalPieceStages.intro => (
          width: 450.0,
          height: 450.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(225),
            boxShadow: _boxShadow,
          ),
        ),
      FocalPieceStages.fab => (
          width: 56.0 * FocalPieceViewModel.fabScale,
          height: 56.0 * FocalPieceViewModel.fabScale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              28 * FocalPieceViewModel.fabScale,
            ),
            boxShadow: _boxShadow,
          ),
        ),
      FocalPieceStages.contact => (
          width: 93.0,
          height: 28.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: _boxShadow,
          ),
        )
    };
  }
}

typedef ContainerParameters = ({
  num width,
  num height,
  BoxDecoration decoration
});

class FocalPiece extends StatelessWidgetConsumer<FocalPieceViewModel> {
  const FocalPiece({super.key});

  @override
  Widget consume(_, vm) {
    return Stack(
      children: [
        Provider(vm.contactCard, child: const ContactCardContainer()),
        AnimatedAlign(
          alignment: vm.alignment,
          duration: vm.animationDuration,
          curve: FocalPieceViewModel.animationCurve,
          child: Padding(
            padding: vm.padding,
            child: SizedBox(
              width: vm.outerSize.width,
              height: vm.outerSize.height,
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                child: Reprovider(
                  selector: (FocalPieceViewModel vm) => vm.container,
                  child: MotionBlur(
                    enabled: vm.motionBlurEnabled,
                    intensity: 0.4,
                    child: const Padding(
                      padding: EdgeInsets.all(100),
                      child: FocalPieceContainer(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FocalPieceBackground
    extends StatelessWidgetConsumer<FocalPieceViewModel> {
  const FocalPieceBackground({super.key});

  @override
  Widget consume(_, vm) {
    return IgnorePointer(
      ignoring: vm.backgroundShouldIgnorePointer,
      child: GestureDetector(
        onTap: vm.content.onCloseContactCard,
        child: AnimatedContainer(
          duration: vm.animationDuration,
          color: vm.backgroundColor,
        ),
      ),
    );
  }
}
