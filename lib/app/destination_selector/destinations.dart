import 'package:website/main.dart';

class Destinations {
  static final home = Destination(
      origin: (Size size) => const Offset(0, 0),
      getScale: (_) => 1,
      title: "Home",
      path: '/');

  static final bsvNews = ProjectDestination(
    title: 'BSV News',
    subtitle: 'Fullstack Development',
    path: '/bsvNews',
    key: _bsvNewsKey,
    content: Container(color: Colors.green),
  );

  static final changeEmitter = ProjectDestination(
    path: '/changeEmitter',
    title: 'change_emitter',
    subtitle: 'Flutter Expertise',
    content: const Placeholder(),
    key: _changeEmitterKey,
  );

  static final verso = ProjectDestination(
    title: 'Verso',
    subtitle: 'Product Design',
    path: '/verso',
    key: _versoKey,
    content: Container(color: Colors.purple),
  );

  static final _bsvNewsKey = GlobalKey();
  static final _changeEmitterKey = GlobalKey();
  static final _versoKey = GlobalKey();

  static final all = [home, bsvNews, verso, changeEmitter];
}
