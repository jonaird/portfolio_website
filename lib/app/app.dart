import 'package:website/main.dart';
import 'theme.dart';

class AppViewModel extends RootEmitter {
  late final Destination initialDestination;
  final destination = ValueEmitter<Destination>(Destinations.home);
  final focalPiece = FocalPieceViewModel();
  late final showBackButton = ValueEmitter.reactive(
      reactTo: [destination],
      withValue: () => destination.value != Destinations.home);
  final showFullBio = ValueEmitter(false);
  final theme = ValueEmitter(AppTheme.dark);

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
        theme,
      };
  @override
  get dependencies => {destination, theme};
}

final _appViewModel = AppViewModel();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AppViewModel>(_appViewModel,
        builder: (context, appViewModel) {
      return MaterialApp.router(
        routeInformationParser: RouteInfoParser(),
        routerDelegate:
            RouterDelegateState(const _RouterChild(), _appViewModel),
        theme: appViewModel.theme.value.themeData,
        debugShowCheckedModeBanner: false,
      );
    });
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
          // backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: const DestinationSelector(),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final title = context.select<AppViewModel, String>((vm) => vm.title)!;
    return Text(
      title,
    );
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
        : const SizedBox();
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

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
        child: Reprovider<AppViewModel, ValueEmitter<AppTheme>>(
            selector: (appViewModel) => appViewModel.theme,
            builder: (context, theme) {
              return IconButton(
                onPressed: theme.toggle,
                icon: Icon(
                  switch (theme.value) {
                    AppTheme.light => Icons.mode_night_outlined,
                    AppTheme.dark => Icons.wb_sunny_outlined
                  },
                ),
              );
            }),
      ),
    );
  }
}
