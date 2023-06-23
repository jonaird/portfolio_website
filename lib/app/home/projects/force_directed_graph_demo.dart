import 'package:website/main.dart';
import 'dart:math';
import 'package:force_directed_graph/force_directed_graph.dart';

class ForceDirectedGraphViewModel extends EmitterContainer {
  int _counter = 0;
  final _nodes = {0};
  final _edges = <Edge<int>>{};
  final r = Random();

  final controller = GraphController<int>();
  int get count => _counter;
  Set<int> get nodes => _nodes;
  Set<Edge<int>> get edges => _edges;

  void incrementCounter() {
    for (final node in nodes) {
      controller.unpinNode(node);
    }
    _nodes.add(_nodes.length);
    _counter++;
    _addRandomEdge();
    _addRandomEdge();
    emit();
  }

  void onAnimationEnd() {
    for (final node in nodes) {
      controller.pinNode(node);
    }
  }

  void _addRandomEdge() {
    var firstNode = _nodes.toList()[r.nextInt(_nodes.length)];
    var secondNode = _nodes.toList()[r.nextInt(_nodes.length)];
    while (firstNode == secondNode) {
      secondNode = _nodes.toList()[r.nextInt(_nodes.length)];
    }
    var edge = Edge<int>(firstNode, secondNode);
    if (!_edges.contains(edge)) _edges.add(edge);
  }
}

class ForceDirectedGraphDemo extends StatelessWidget {
  const ForceDirectedGraphDemo({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'force_directed_graph Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Demo(title: 'Force Directed Graph Demo'),
    );
  }
}

class Demo extends StatelessWidgetConsumer<ForceDirectedGraphViewModel> {
  const Demo({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget consume(BuildContext context, vm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  vm.count.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => GraphView(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              nodes: vm.nodes,
              edges: vm.edges,
              controller: vm.controller,
              onAnimationEnd: vm.onAnimationEnd,
              curve: Curves.elasticOut,
              algorithm: const FruchtermanReingoldAlgorithm(iterations: 300),
              duration: const Duration(milliseconds: 1200),
              nodeBuilder: (data, context) => FloatingActionButton(
                onPressed: vm.incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              edgeBuilder: (_, __, ___) => Container(
                height: 3,
                color: Colors.black,
              ),
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
