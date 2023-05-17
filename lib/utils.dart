import './main.dart';

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

  bool get atHome =>
      depend<AppViewModel>()!.destination.value == Destinations.home;

  AppViewModel get appViewModel => read<AppViewModel>()!;
}

abstract class ConsumerStatelessWidget<C extends ChangeEmitter>
    extends StatelessWidget {
  const ConsumerStatelessWidget({super.key});

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
