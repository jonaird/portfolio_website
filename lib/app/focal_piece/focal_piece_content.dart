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
    return switch (parent.stage) {
      FocalPieceStages.firstBuild => CrossFadeState.showFirst,
      FocalPieceStages.intro => CrossFadeState.showFirst,
      FocalPieceStages.fab => CrossFadeState.showSecond,
      FocalPieceStages.contact => CrossFadeState.showFirst,
    };
  }

  void onCloseContactCard() {
    parent.stage = FocalPieceStages.fab;
  }

  void onFABPressed() {
    parent.stage = FocalPieceStages.contact;
  }

  void sendMessage() => parent.sendMessage();

  @override
  get dependencies => {parent};
}

class FocalPieceContent
    extends StatelessWidgetConsumer<FocalPieceContentViewModel> {
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
        layoutBuilder: _layoutBuilder,
      ),
    );
  }

  Widget _layoutBuilder(
    Widget topChild,
    Key topChildKey,
    Widget bottomChild,
    Key bottomChildKey,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: <Widget>[
        bottomChild,
        topChild,
      ],
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
          message: "Contact",
          preferBelow: false,
          verticalOffset: 30,
          child: InkWell(
            onTap: context.appViewModel.focalPiece.content.onFABPressed,
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
        child: ElevatedButton.icon(
            onPressed: context.read<FocalPieceContentViewModel>()!.sendMessage,
            icon: const Icon(Icons.send),
            label: const Text('Send'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary)),
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
          onPressed: () {},
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
            onPressed: () {},
            icon: const Icon(Icons.open_in_browser),
            label: const Text('Visit')),
      ),
      tileColor: Colors.black12,
    );
  }
}
