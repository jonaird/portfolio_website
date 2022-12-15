import '../main.dart';
import 'intro_animation.dart';

export 'logo_widget.dart';
export '../main.dart';
export 'menu_bar.dart';
export 'scroll_overlay.dart';

class Overlays extends StatelessWidget {
  const Overlays({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final dest = Destination.of(context);
    return Stack(children: [
      child,
      if (dest == Destinations.home) const PageHoverOverlay(),
      const MenuBarOverlay(),
      const IntroAnimation(),
      const LogoWidget(),
    ]);
  }
}
