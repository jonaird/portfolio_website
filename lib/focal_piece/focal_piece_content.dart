import 'package:website/main.dart';

class FocalPieceContentViewModel extends EmitterContainer {
  @override
  FocalPieceViewModel get parent => super.parent as FocalPieceViewModel;

  Duration get animationDuration {
    return parent.animationDuration;
    // if (parent.stage == FocalPieceStages.firstBuild) return Duration.zero;
    // return FocalPieceViewModel.animationDuration;
  }

  Widget get firstChild {
    if (parent.introSequenceCompleted) return const _ContactCard();
    return const _Logo();
  }

  Widget get secondChild {
    return _FabContent();
  }

  CrossFadeState get crossFadeState {
    switch (parent.stage) {
      case FocalPieceStages.firstBuild:
        return CrossFadeState.showFirst;
      case FocalPieceStages.intro:
        return CrossFadeState.showFirst;
      case FocalPieceStages.fab:
        return CrossFadeState.showSecond;
      case FocalPieceStages.contact:
        return CrossFadeState.showFirst;
    }
  }

  void onCloseContactCard() {
    parent.stage = FocalPieceStages.fab;
  }

  void onFABPressed() {
    parent.stage = FocalPieceStages.contact;
  }

  @override
  get dependencies => {parent};
}

class FocalPieceContent
    extends ConsumerStatelessWidget<FocalPieceContentViewModel> {
  const FocalPieceContent({super.key});

  @override
  Widget consume(_, vm) {
    return Center(
      child: AnimatedCrossFade(
        duration: vm.animationDuration,
        firstCurve: FocalPieceViewModel.animationCurve,
        secondCurve: FocalPieceViewModel.animationCurve,
        sizeCurve: FocalPieceViewModel.animationCurve,
        firstChild: vm.firstChild,
        secondChild: vm.secondChild,
        crossFadeState: vm.crossFadeState,
        alignment: Alignment.center,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.memory(
        logoBytes,
        width: 300,
        height: 300,
      ),
    );
  }
}

const _scale = 300;

class _FabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      shape: const CircleBorder(),
      child: FittedBox(
        fit: BoxFit.contain,
        child: InkWell(
          onTap: context.appViewModel.focalPiece.contentViewModel.onFABPressed,
          borderRadius:
              BorderRadius.circular(56 * FocalPieceViewModel.fabScale * _scale),
          child: const Padding(
            padding:
                EdgeInsets.all(16.0 * FocalPieceViewModel.fabScale * _scale),
            child: Icon(
              size: 24 * FocalPieceViewModel.fabScale * _scale,
              Icons.email_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(children: [
        Container(
          alignment: Alignment.topRight,
          child: Material(
            color: Theme.of(context).primaryColor,
            child: IconButton(
              onPressed: context
                  .appViewModel.focalPiece.contentViewModel.onCloseContactCard,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}