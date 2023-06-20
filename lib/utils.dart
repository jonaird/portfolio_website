import './main.dart';

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
    return const Size(330, 200);
    // return (currentContext!.findRenderObject()! as RenderBox).size;
  }

  bool get offsetIsAvailable => currentContext?.findRenderObject() is RenderBox;
}

extension StateExtensions on State {
  Size get size {
    return MediaQuery.of(context).size;
  }
}

extension StatelessExtensions on StatelessWidget {
  Size size(BuildContext context) => MediaQuery.of(context).size;
}

extension ContextExtensions on BuildContext {
  Size get windowSize => MediaQuery.of(this).size;
}

abstract class StatelessWidgetConsumer<C extends ChangeEmitter>
    extends StatelessWidget {
  const StatelessWidgetConsumer({super.key});

  Widget consume(BuildContext context, C changeEmitter);

  @override
  Widget build(BuildContext context) {
    return Consumer<C>(
      builder: (context, changeEmitter) => consume(
        context,
        changeEmitter,
      ),
    );
  }
}

abstract class ConsumerState<S extends StatefulWidget, C extends ChangeEmitter>
    extends State<S> {
  Widget consume(BuildContext context, C changeEmitter);

  @override
  Widget build(BuildContext context) {
    return Consumer<C>(
      builder: (context, changeEmitter) => consume(
        context,
        changeEmitter,
      ),
    );
  }
}

abstract class StatelessWidgetReprovider<E extends ChangeEmitter,
    S extends ChangeEmitter> extends StatelessWidget {
  const StatelessWidgetReprovider({super.key});

  S select(E emitter);

  Widget reprovide(BuildContext context, S emitter);

  @override
  Widget build(BuildContext context) {
    return Reprovider<E, S>(
      selector: select,
      builder: reprovide,
    );
  }
}
