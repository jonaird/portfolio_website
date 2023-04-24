import 'package:website/main.dart';
import 'focal_piece_content.dart';

class FocalPieceBackgroundViewModel extends EmitterContainer {
  @override
  FocalPieceViewModel get parent => super.parent as FocalPieceViewModel;
  late final _backgroundParameters = ValueEmitter.reactive(
    reactTo: [parent],
    withValue: () => getBackgroundParameters,
    keepHistory: true,
  );

  BackgroundParameters get backgroundParameters => _backgroundParameters.value;

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

  BackgroundParameters get getBackgroundParameters {
    switch (parent.stage) {
      case FocalPieceStages.firstBuild:
        return BackgroundParameters(
          width: 2000,
          height: 2000,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5252),
            borderRadius: BorderRadius.circular(1000),
          ),
        );
      case FocalPieceStages.intro:
        return BackgroundParameters(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5252),
            borderRadius: BorderRadius.circular(150),
          ),
        );
      case FocalPieceStages.fab:
        return BackgroundParameters(
          // width: 120 * FocalPieceViewModel.fabScale,
          width: 56 * FocalPieceViewModel.fabScale,
          height: 56 * FocalPieceViewModel.fabScale,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5252),
            // color: !useInkwell ? const Color(0xFFFF5252) : null,
            borderRadius:
                BorderRadius.circular(28 * FocalPieceViewModel.fabScale),
          ),
        );
      case FocalPieceStages.contact:
        return BackgroundParameters(
          width: 350,
          height: 400,
          decoration: BoxDecoration(
            // color: const Color(0xFFFF5252),
            color: const Color(0xFFFF5252),
            borderRadius:
                BorderRadius.circular(6 * FocalPieceViewModel.fabScale),
          ),
        );
    }
  }

  @override
  get dependencies => {_backgroundParameters};
}

class BackgroundParameters {
  const BackgroundParameters(
      {required this.width, required this.height, required this.decoration});
  final double width;
  final double height;
  final BoxDecoration decoration;

  @override
  bool operator ==(Object other) =>
      other is BackgroundParameters &&
      other.width == width &&
      other.height == height &&
      other.decoration == decoration;

  @override
  int get hashCode => Object.hash(width, height, decoration);
}

class FocalPieceBackground extends StatefulWidget {
  const FocalPieceBackground({super.key});

  @override
  State<FocalPieceBackground> createState() => _FocalPieceBackgroundState();
}

class _FocalPieceBackgroundState extends State<FocalPieceBackground> {
  var initialBuild = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<FocalPieceBackgroundViewModel>(
      builder: (context, fp) {
        if (fp.firstBuild) fp.onFirstBuild();
        return Padding(
          padding: const EdgeInsets.all(16.0 * 3),
          child: AnimatedContainer(
            key: const Key('animatedCotnainer'),
            width: fp.backgroundParameters.width,
            height: fp.backgroundParameters.height,
            curve: FocalPieceViewModel.animationCurve,
            duration: fp.animationDuration,
            onEnd: fp.finishedAnimating,
            decoration: fp.backgroundParameters.decoration,
            child: Reprovider(
              selector: (FocalPieceViewModel vm) => vm.contentViewModel,
              child: const FocalPieceContent(),
            ),
          ),
        );
      },
    );
  }
}
