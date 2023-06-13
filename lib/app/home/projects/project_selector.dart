import 'package:website/main.dart';

class ProjectSelector extends StatefulWidget {
  const ProjectSelector({Key? key}) : super(key: key);

  @override
  State<ProjectSelector> createState() => _ProjectSelectorState();
}

class _ProjectSelectorState extends State<ProjectSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _originAnimation;
  Project? _selectedProject;
  var _initialBuild = true;
  late Size _lastWindowSize = MediaQuery.of(context).size;

  @override
  void didChangeDependencies() {
    final selectedProject = Project.of(context);
    if (_initialBuild) {
      _selectedProject = selectedProject;
      _controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      _controller.addListener(() => setState(() {}));
      _scaleAnimation = _controller.drive<double>(Tween<double>(
        begin: _selectedProject?.scale ?? 1,
        end: _selectedProject?.scale ?? 1,
      ));
      _originAnimation = _controller.drive(
          Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0)));
      _initialBuild = false;
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          context.read<AppViewModel>()!.animating.value = true;
        } else if (status == AnimationStatus.completed) {
          context.read<AppViewModel>()!.animating.value = false;
        }
      });
    } else if (selectedProject != _selectedProject) {
      goTo(selectedProject);
    }

    super.didChangeDependencies();
  }

  void goTo(Project? newSelectedProject) {
    var curved = CurvedAnimation(
      parent: _controller,
      curve:
          newSelectedProject == null ? Curves.easeInOut : Curves.fastOutSlowIn,
    );

    final originCurve = CurvedAnimation(
        parent: _controller,
        curve: newSelectedProject is Project
            ? Curves.easeOutExpo
            : Curves.fastOutSlowIn);

    _scaleAnimation = curved.drive<double>(Tween<double>(
      begin: _selectedProject?.scale ?? 1,
      end: newSelectedProject?.scale ?? 1,
    ));
    _originAnimation = originCurve.drive(Tween<Offset>(
      begin: _selectedProject == null
          ? newSelectedProject!.origin
          : _selectedProject!.origin,
      end: newSelectedProject == null
          ? _selectedProject!.origin
          : newSelectedProject.origin,
    ));
    _controller.value = 0;
    _controller.forward();

    _selectedProject = newSelectedProject;
  }

  void checkForWindowResize() {
    final currentSize = MediaQuery.of(context).size;
    if (currentSize != _lastWindowSize) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _originAnimation = _controller.drive(Tween<Offset>(
              begin: _selectedProject?.origin ?? const Offset(0, 0),
              end: _selectedProject?.origin ?? const Offset(0, 0)));
        });
      });
    }
    _lastWindowSize = currentSize;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkForWindowResize();
    return Stack(
      children: [
        Transform.scale(
          scale: _scaleAnimation.status == AnimationStatus.forward
              ? _scaleAnimation.value
              : _selectedProject?.scale ?? 1,
          origin: _originAnimation.value,
          alignment: Alignment.topLeft,
          child: const HomePage(),
        ),
        const ThemeSwitcher()
      ],
    );
  }
}
