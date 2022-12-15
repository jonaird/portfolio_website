import 'package:website/main.dart';

class Destination {
  Destination({
    required this.origin,
    required this.getScale,
    required this.title,
    required this.path,
  });

  factory Destination.fromUri(String uri) {
    final destList = [...Destinations.all]
      ..retainWhere((element) => element.path == uri);
    if (destList.isEmpty) throw ('bad url');
    return destList.first;
    // switch (uri) {
    //   case '/':
    //     return Destinations.home;
    //   case '/aboutMe':
    //     return Destinations.aboutMe;
    //   case '/experience':
    //     return Destinations.experience;
    //   case '/projects':
    //     return Destinations.projects;
    //   case '/philosophy':
    //     return Destinations.philosophy;
    //   default:
    //     throw ('invalid uri');
    // }
  }

  final Offset Function(Size size) origin;
  final double Function(Size size) getScale;
  final String title;
  final String path;

  Offset translation(Size size) {
    return const Offset(0, 0);
  }

  bool get useScrollOverlay => this is PageDestination;

  static Destination of(BuildContext context) {
    return context
        .select<AppState, Destination>((state) => state.destination.value)!;
  }
}

class ProjectDestination extends Destination {
  ProjectDestination({
    required super.origin,
    required super.getScale,
    required super.path,
    required super.title,
    required this.key,
  });
  final GlobalKey key;

  static Offset Function(Size) originGetterFromKey(GlobalKey key) {
    return (size) {
      final y = key.offset.dy +
          key.offset.dy / (size.height * scaleMultiple / 100 - 1);
      final x = key.offset.dx +
          key.offset.dx / (size.height * scaleMultiple / 100 - 1);
      return Offset(x, y);
    };
  }
}

extension OS on GlobalKey {
  Offset get offset {
    late RenderObject canvasRenderObject;
    currentContext!.visitAncestorElements(
      (element) {
        if (element.widget is FullCanvas) {
          canvasRenderObject = element.renderObject!;
          return false;
        }
        return true;
      },
    );
    return (currentContext?.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero, ancestor: canvasRenderObject);
  }

  bool get offsetIsAvailable => currentContext?.findRenderObject() is RenderBox;
}

class PageDestination extends Destination {
  PageDestination({
    required super.origin,
    required super.getScale,
    required super.title,
    required super.path,
    required this.color,
    required this.content,
    required this.horizontalPosition,
    required this.verticalPosition,
  });
  final HorizontalPosition horizontalPosition;
  final VerticalPosition verticalPosition;
  final Widget content;
  final Color color;
  Widget get widget => AppPage(destination: this);

  static Destination fromPosition(
    HorizontalPosition horizontalPosition,
    VerticalPosition verticalPosition,
  ) {
    var proj = [
      Destinations.projects,
      Destinations.experience,
      Destinations.aboutMe,
      Destinations.philosophy,
    ]..retainWhere((element) =>
        element.horizontalPosition == horizontalPosition &&
        element.verticalPosition == verticalPosition);
    return proj.first;
  }
}

enum HorizontalPosition {
  left(),
  right();

  HorizontalPosition get opposite {
    if (this == HorizontalPosition.left) return HorizontalPosition.right;
    return HorizontalPosition.left;
  }
}

enum VerticalPosition {
  top,
  bottom;

  VerticalPosition get opposite {
    if (this == VerticalPosition.top) return VerticalPosition.bottom;
    return VerticalPosition.top;
  }
}
