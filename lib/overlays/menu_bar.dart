import 'overlays.dart';

class MenuBarOverlay extends StatelessWidget {
  const MenuBarOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(0, Destination.of(context) is PageDestination ? 0 : -1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      child: const MenuBar(),
    );
  }
}

class MenuBar extends StatefulWidget {
  const MenuBar({super.key});

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> with SingleTickerProviderStateMixin {
  late final _controller = TabController(length: 4, vsync: this);
  var _skipNotif = false;
  @override
  void initState() {
    context.appState.destination.changes.listen((event) {
      if (!_skipNotif && event.newValue is PageDestination) {
        _controller.index =
            Destinations.pages.indexOf(event.newValue as PageDestination);
      }
      _skipNotif = false;
    });
    _controller.addListener(() {
      _skipNotif = true;
      context.appState.destination.value =
          Destinations.pages[_controller.index];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const height = 65.0;
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: PreferredSize(
          preferredSize: const Size.fromHeight(height),
          child: SizedBox(
            height: height,
            child: TabBar(
              indicatorWeight: 7,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              controller: _controller,
              labelStyle: const TextStyle(fontSize: 23),
              unselectedLabelStyle: const TextStyle(fontSize: 20),
              tabs: Destinations.pages
                  .map((e) => Tab(text: e.title, height: 70))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
