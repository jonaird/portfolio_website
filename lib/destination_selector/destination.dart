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
  }

  final Offset Function(Size size) origin;
  final double Function(Size size) getScale;
  final String title;
  final String path;

  Offset translation(Size size) {
    return const Offset(0, 0);
  }

  // bool get useScrollOverlay => this is PageDestination;

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
          getScale: (size) =>
              scaleMultiple * size.height / key.projectCardSize.height,
          origin: ProjectDestination.originGetterFromKey(key),
        );
  final GlobalKey key;
  final Widget content;
  final String subtitle;

  static Offset Function(Size) originGetterFromKey(GlobalKey key) {
    return (size) {
      final y = key.offset.dy +
          key.offset.dy /
              (size.height * scaleMultiple / key.projectCardSize.height - 1);
      final x = key.offset.dx +
          key.offset.dx /
              (size.height * scaleMultiple / key.projectCardSize.height - 1);
      return Offset(x, y);
    };
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

// class PageDestination extends Destination {
//   PageDestination({
//     required super.title,
//     required super.path,
//     required this.color,
//     required this.content,
//     required this.horizontalPosition,
//     required this.verticalPosition,
//   }) : super(
//           getScale: (_) => scaleMultiple,
//           origin: PageDestination.originGetterFromPosition(
//             horizontalPosition,
//             verticalPosition,
//           ),
//         );
//   final HorizontalPosition horizontalPosition;
//   final VerticalPosition verticalPosition;
//   final Widget content;
//   final Color color;
//   Widget get widget => AppPage(destination: this);

//   // static Destination fromPosition(
//   //   HorizontalPosition horizontalPosition,
//   //   VerticalPosition verticalPosition,
//   // ) {
//   //   var proj = [
//   //     Destinations.projects,
//   //     Destinations.experience,
//   //     Destinations.aboutMe,
//   //     Destinations.philosophy,
//   //   ]..retainWhere((element) =>
//   //       element.horizontalPosition == horizontalPosition &&
//   //       element.verticalPosition == verticalPosition);
//   //   return proj.first;
//   // }

//   static Offset Function(Size) originGetterFromPosition(
//     HorizontalPosition horizontalPosition,
//     VerticalPosition verticalPosition,
//   ) {
//     //formula for this comes from the fact that we need an origin
//     //that results in a point at 1/4W should end at 1/2W when zoomed by the
//     //scale factor.
//     // ----O---A-------X-----------------
//     //where O is origin, A is 1/4W and X is at 1/2W
//     //length of OA*scalefactor should equal OX
//     //
//     //An analogous calculation is used for the y coordinates
//     double getA(Size size) {
//       return size.width / (4 * (scaleMultiple - 1));
//     }

//     double getB(Size size) {
//       return size.height / (2 * scaleMultiple - 2);
//     }

//     final getX = horizontalPosition == HorizontalPosition.left
//         ? (size) => size.width / 4 - getA(size)
//         : (size) => size.width * 3 / 4 + getA(size);

//     final getY = verticalPosition == VerticalPosition.top
//         ? (size) => 0.0
//         : (size) => size.height / 2 + getB(size);
//     return (size) => Offset(getX(size), getY(size));
//   }
// }

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
