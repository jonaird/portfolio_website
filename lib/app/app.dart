import 'package:website/main.dart';

class AppViewModel extends RootEmitter {
  late final Destination initialDestination;
  final destination = ValueEmitter<Destination>(Destinations.home);
  final focalPiece = FocalPieceViewModel();
  late final showBackButton = ValueEmitter.reactive(
      reactTo: [destination],
      withValue: () => destination.value != Destinations.home);
  final showFullBio = ValueEmitter(false);

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
        showFullBio,
      };
  @override
  get dependencies => {destination};
}

final _routerDelegate = RouterDelegateState(const _RouterChild());
const _textTheme = Typography.whiteHelsinki;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const baseColor = Colors.blueGrey;
    return MaterialApp.router(
      routeInformationParser: RouteInfoParser(),
      routerDelegate: _routerDelegate,
      theme: ThemeData(
        primaryColorLight: baseColor.shade400,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: baseColor.shade700,
          onPrimary: Colors.white,
          secondary: Colors.redAccent.shade200,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: baseColor.shade900,
          onBackground: Colors.white,
          surface: baseColor.shade700,
          onSurface: Colors.white,
        ),
        textTheme: _textTheme.copyWith(
          bodyLarge: _textTheme.bodyMedium!.copyWith(
              fontSize: 24,
              color: Colors.white.withAlpha(170),
              fontWeight: FontWeight.w100),
          displaySmall: _textTheme.displaySmall!.copyWith(
            color: Colors.white.withAlpha(200),
          ),
          displayMedium: _textTheme.displayMedium!.copyWith(
            color: Colors.white.withAlpha(200),
            height: 0.98,
          ),
          displayLarge: _textTheme.displayLarge!.copyWith(
            fontSize: 84,
            color: Colors.white.withAlpha(200),
            height: 0.98,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.lightBlue.shade600,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _RouterChild extends StatelessWidget {
  const _RouterChild();

  @override
  Widget build(BuildContext context) {
    return Overlays(
      child: Scaffold(
        appBar: AppBar(
          title: const _Title(),
          automaticallyImplyLeading: false,
          leading: const _Leading(),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
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
          builder: (_) => BuiltWithFlutterCornerBanner.positioned(
            bannerPosition: CornerBannerPosition.topRight,
            bannerColor: Theme.of(context).primaryColorLight,
            elevation: 2,
          ),
        ),
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
