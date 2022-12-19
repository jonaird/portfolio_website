import 'package:website/main.dart';

class Destinations {
  static final home = Destination(
      origin: (Size size) => const Offset(0, 0),
      getScale: (_) => 1,
      title: "Home",
      path: '/');
  static final aboutMe = PageDestination(
    color: const Color(0xFFFFF5AE),
    content: const AboutMePage(),
    horizontalPosition: HorizontalPosition.left,
    verticalPosition: VerticalPosition.top,
    title: 'About Me',
    path: '/aboutMe',
  );
  static final experience = PageDestination(
      color: const Color(0xFFC0E3FF),
      content: const ExperiencePageContent(),
      horizontalPosition: HorizontalPosition.right,
      verticalPosition: VerticalPosition.top,
      title: 'Experience',
      path: '/experience');
  static final projects = PageDestination(
      color: const Color(0xFFF2D9FF),
      content: const ProjectsPageContent(),
      horizontalPosition: HorizontalPosition.left,
      verticalPosition: VerticalPosition.bottom,
      title: 'Projects',
      path: '/projects');
  static final philosophy = PageDestination(
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
