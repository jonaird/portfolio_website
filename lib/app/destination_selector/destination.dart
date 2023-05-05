import 'package:website/main.dart';

class Destination {
  Destination({
    required this.getScale,
    required this.title,
    required this.path,
  });

  factory Destination.fromUri(String uri) {
    final destList = [...Destinations.all]
      ..retainWhere((element) => element.path == uri);
    if (destList.isEmpty) throw ('bad url');
    return destList.first;
  }

  final double Function(Size size) getScale;
  final String title;
  final String path;

  Offset get origin => const Offset(0, 0);

  static Destination of(BuildContext context) {
    return context
        .select<AppViewModel, Destination>((state) => state.destination.value)!;
  }
}

class ProjectDestination extends Destination {
  ProjectDestination({
    required super.path,
    required super.title,
    required this.subtitle,
    required this.content,
    required this.key,
  }) : super(
          getScale: (size) => size.height / key.projectCardSize.height,
        );
  final GlobalKey key;
  final Widget content;
  final String subtitle;

  @override
  Offset get origin {
    final size = MediaQuery.of(key.currentContext!).size;
    final y = key.offset.dy +
        key.offset.dy / (size.height / key.projectCardSize.height - 1);
    final scaledWidth = (size.width * key.projectCardSize.height / size.height);
    final scaledOffsetX =
        key.offset.dx + (key.projectCardSize.width - scaledWidth) / 2;
    final x = scaledOffsetX +
        scaledOffsetX / (size.height / key.projectCardSize.height - 1);
    return Offset(x, y);
  }
}

extension OS on GlobalKey {
  Offset get offset {
    late RenderObject canvasRenderObject;
    currentContext!.visitAncestorElements(
      (element) {
        // if (element.widget is FullCanvas) {
        if (element.widget is HomePage) {
          canvasRenderObject = element.renderObject!;
          return false;
        }
        return true;
      },
    );
    return (currentContext?.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero, ancestor: canvasRenderObject);
  }

  Size get projectCardSize {
    return (currentContext!.findRenderObject()! as RenderBox).size;
  }

  bool get offsetIsAvailable => currentContext?.findRenderObject() is RenderBox;
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
