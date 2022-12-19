import 'package:website/main.dart';

double _getA(Size size) {
  return size.width / (4 * (scaleMultiple - 1));
}

double _getB(Size size) {
  return size.height / (2 * scaleMultiple - 2);
}

class Destinations {
  static final home = Destination(
      origin: (Size size) => const Offset(0, 0),
      getScale: (_) => 1,
      title: "Home",
      path: '/');
  static final aboutMe = PageDestination(
    //formula for this comes from the fact that we need an origin
    //that results in a point at 1/4W should end at 1/2W when zoomed by the
    //scale factor.
    // ----O---A-------B-----------------
    //where O is origin, A is 1/4W and B is at 1/2W
    //length of OA*scalefactor should equal OB
    origin: (Size size) => Offset(size.width / 4 - _getA(size), 0),
    getScale: (_) => scaleMultiple,
    color: const Color(0xFFFFF5AE),
    content: const AboutMePage(),
    horizontalPosition: HorizontalPosition.left,
    verticalPosition: VerticalPosition.top,
    title: 'About Me',
    path: '/aboutMe',
  );
  static final experience = PageDestination(
      origin: (Size size) => Offset(size.width * 3 / 4 + _getA(size), 0),
      getScale: (_) => scaleMultiple,
      color: const Color(0xFFC0E3FF),
      content: const ExperiencePageContent(),
      horizontalPosition: HorizontalPosition.right,
      verticalPosition: VerticalPosition.top,
      title: 'Experience',
      path: '/experience');
  static final projects = PageDestination(
      origin: (Size size) =>
          Offset(size.width / 4 - _getA(size), size.height / 2 + _getB(size)),
      getScale: (_) => scaleMultiple,
      color: const Color(0xFFF2D9FF),
      content: const ProjectsPageContent(),
      horizontalPosition: HorizontalPosition.left,
      verticalPosition: VerticalPosition.bottom,
      title: 'Projects',
      path: '/projects');
  static final philosophy = PageDestination(
      origin: (Size size) => Offset(
          size.width * 3 / 4 + _getA(size), size.height / 2 + _getB(size)),
      getScale: (_) => scaleMultiple,
      color: const Color.fromARGB(255, 222, 255, 192),
      content: const PhilosophyPageContent(),
      horizontalPosition: HorizontalPosition.right,
      verticalPosition: VerticalPosition.bottom,
      title: 'Philosophy',
      path: '/philosophy');

  static final bsvNews = ProjectDestination(
    title: 'BSV News',
    path: 'projects/bsvNews',
    key: _bsvNewsKey,
    content: Container(color: Colors.green),
  );
  static final verso = ProjectDestination(
    title: 'Verso',
    path: 'projects/bsvNews',
    key: _versoKey,
    content: Container(color: Colors.purple),
  );
  static final forceDirectedGraph = ProjectDestination(
      path: 'projects/forceDirectedGraph',
      title: 'force_directed_graph',
      content: const ForceDirectedGraphDemo(),
      key: _graphKey);

  static final _bsvNewsKey = GlobalKey();
  static final _graphKey = GlobalKey();
  static final _versoKey = GlobalKey();

  static final pages = [
    aboutMe,
    experience,
    projects,
    philosophy,
  ];

  static final all = [
    home,
    aboutMe,
    experience,
    projects,
    philosophy,
    bsvNews,
    verso,
  ];
}
