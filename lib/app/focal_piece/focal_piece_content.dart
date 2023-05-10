import 'package:website/main.dart';

class FocalPieceContentViewModel extends EmitterContainer {
  @override
  FocalPieceViewModel get parent => super.parent as FocalPieceViewModel;

  Duration get animationDuration {
    return parent.animationDuration;
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

class _FabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fab = context.select<FocalPieceViewModel, bool>(
        (vm) => vm.stage == FocalPieceStages.fab)!;
    return SizedBox(
      width: fab ? 300 : null,
      height: fab ? 300 : null,
      child: FittedBox(
        fit: BoxFit.contain,
        child: InkWell(
          onTap: context.appViewModel.focalPiece.contentViewModel.onFABPressed,
          borderRadius:
              BorderRadius.circular(56 * FocalPieceViewModel.fabScale),
          child: const Padding(
            padding: EdgeInsets.all(16.0 * FocalPieceViewModel.fabScale),
            child: Icon(
              size: 24 * FocalPieceViewModel.fabScale,
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
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 450,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: const [_CloseButton(), Gap(20), _Email()],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed:
            context.appViewModel.focalPiece.contentViewModel.onCloseContactCard,
        tooltip: 'Close',
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text('jonathan.aird@gmail.com',
            style: TextStyle(
                fontSize: 19,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        Tooltip(
          message: 'Copy to clipboard',
          child: ElevatedButton.icon(
            onPressed: () => null,
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
            // style: ElevatedButton.styleFrom(backgroundColor: Colors.)),
          ),
        )
      ],
    );
  }
}
