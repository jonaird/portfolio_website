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
        layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild,
            Key bottomChildKey) {
          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.passthrough,
            children: <Widget>[
              bottomChild,
              topChild,
            ],
          );
        },
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.memory(
          logoBytes,
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

class _FabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Tooltip(
          message: "email & github",
          preferBelow: false,
          verticalOffset: 30,
          child: InkWell(
            onTap:
                context.appViewModel.focalPiece.contentViewModel.onFABPressed,
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
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 450,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: const [
                _CloseButton(),
                Gap(8),
                _Email(),
                Gap(8),
                _Github(),
              ],
            ),
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

const _listTileTextStyle = TextStyle(
  fontSize: 19,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const SelectableText(
        'jonathan.aird@gmail.com',
        style: _listTileTextStyle,
      ),
      trailing: Tooltip(
        message: 'Copy to clipboard',
        child: ElevatedButton.icon(
          onPressed: () => null,
          icon: const Icon(Icons.copy),
          label: const Text('Copy'),
          // style: ElevatedButton.styleFrom(backgroundColor: Colors.)),
        ),
      ),
      tileColor: Colors.black12,
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: [
    //     const SelectableText(
    //       'jonathan.aird@gmail.com',
    //       style: TextStyle(
    //         fontSize: 19,
    //         color: Colors.white,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     Tooltip(
    //       message: 'Copy to clipboard',
    //       child: ElevatedButton.icon(
    //         onPressed: () => null,
    //         icon: const Icon(Icons.copy),
    //         label: const Text('Copy'),
    //         // style: ElevatedButton.styleFrom(backgroundColor: Colors.)),
    //       ),
    //     )
    //   ],
    // );
  }
}

class _Github extends StatelessWidget {
  const _Github();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          const SelectableText('github.com/jonaird', style: _listTileTextStyle),
      trailing: Tooltip(
        message: 'Open in new tab',
        child: ElevatedButton.icon(
            onPressed: () => null,
            icon: const Icon(Icons.open_in_browser),
            label: const Text('Visit')),
      ),
      tileColor: Colors.black12,
    );
  }
}
