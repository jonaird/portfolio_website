import 'package:website/main.dart';

class AppViewModel extends RootEmitter {
  late final Destination initialDestination;
  final destination = ValueEmitter<Destination>(Destinations.home);
  final focalPiece = FocalPieceViewModel();
  late final showBackButton = ValueEmitter.reactive(
      reactTo: [destination],
      withValue: () => destination.value != Destinations.home);

  void handleBackButton() {
    destination.value = Destinations.home;
  }

  void selectProject(ProjectDestination project) {
    destination.value = project;
  }

  String get title {
    final dest = destination.value;
    if (dest is ProjectDestination) return dest.title;
    return 'Portfolio';
  }

  @override
  get children => {
        destination,
        focalPiece,
        showBackButton,
      };
  @override
  get dependencies => {destination};
}

class App extends ConsumerStatelessWidget<AppViewModel> {
  const App({super.key});

  @override
  Widget consume(BuildContext context, vm) {
    return Overlays(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade700,
          title: const _Title(),
          automaticallyImplyLeading: false,
          leading: const _Leading(),
        ),
        backgroundColor: Colors.blueGrey.shade900,
        body: const DestinationSelector(),
      ),
    );
  }
}

class _Title extends ConsumerStatelessWidget<AppViewModel> {
  const _Title();

  @override
  Widget consume(BuildContext context, vm) {
    return Text(vm.title);
  }
}

class _Leading extends ConsumerStatelessWidget<AppViewModel> {
  const _Leading();

  @override
  Widget consume(BuildContext context, vm) {
    return vm.showBackButton.value
        ? BackButton(
            onPressed: context.appViewModel.handleBackButton,
          )
        : const Placeholder();
  }
}

class Overlays extends StatelessWidget {
  const Overlays({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(builder: (_) => child),
        OverlayEntry(
          builder: (_) => Reprovider(
            selector: (AppViewModel appViewModel) => appViewModel.focalPiece,
            child: const FocalPieceBackground(),
          ),
        ),
        OverlayEntry(
          builder: (_) => Reprovider(
            selector: (AppViewModel appViewModel) => appViewModel.focalPiece,
            child: const FocalPiece(),
          ),
        ),
      ],
    );
  }
}
