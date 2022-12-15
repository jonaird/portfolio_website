import '../main.dart';
export './pages/pages.dart';

class FullCanvas extends StatelessWidget {
  const FullCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    //need to force rebuild on window resizing
    //because the scaleMultiple will have changed

    MediaQuery.of(context).size;
    late Offset offset;
    if (Destinations.bsvNews.key.offsetIsAvailable) {
      offset = Destinations.bsvNews.key.offset;
    }

    return Stack(
      children: [
        Transform.scale(
          scale: 1 / scaleMultiple,
          alignment: Alignment.topLeft,
          child: OverflowBox(
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                const Gap(70),
                Row(
                  children: [
                    AppPage(destination: Destinations.aboutMe),
                    AppPage(destination: Destinations.experience)
                  ],
                ),
                Row(
                  children: [
                    AppPage(destination: Destinations.projects),
                    AppPage(destination: Destinations.philosophy)
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({required this.destination, super.key});
  final PageDestination destination;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * scaleMultiple / 2,
          height: MediaQuery.of(context).size.height * scaleMultiple / 2,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PageBackground(destination),
            ],
          ),
          // DemoBlocks(color: color),
        ),
      ],
    );
  }
}

class PageBackground extends StatelessWidget {
  const PageBackground(this.destination, {super.key});
  final PageDestination destination;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      child: Card(
        shape: const Border(),
        margin: const EdgeInsets.all(30),
        elevation: 10,
        // shadowColor: widget.color,
        color: destination.color,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: destination.content),
      ),
    );
  }
}

class DemoText extends StatelessWidget {
  const DemoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.genos(fontSize: 19),
    );
  }
}

const text = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Semper eget duis at tellus at urna. Adipiscing elit duis tristique sollicitudin nibh sit amet. Sed risus pretium quam vulputate dignissim. Ut diam quam nulla porttitor massa id neque. Feugiat scelerisque varius morbi enim. Nec ullamcorper sit amet risus nullam eget felis eget nunc. Nunc id cursus metus aliquam eleifend mi in. Urna condimentum mattis pellentesque id nibh tortor. Facilisis magna etiam tempor orci eu lobortis. Varius duis at consectetur lorem donec. Laoreet non curabitur gravida arcu ac tortor. Tincidunt nunc pulvinar sapien et ligula ullamcorper.

Eu volutpat odio facilisis mauris. Sed vulputate mi sit amet. Vestibulum morbi blandit cursus risus at ultrices mi tempus imperdiet. Vel orci porta non pulvinar neque laoreet suspendisse. Morbi tristique senectus et netus. Lobortis elementum nibh tellus molestie nunc. Faucibus interdum posuere lorem ipsum dolor sit. Maecenas sed enim ut sem viverra. Lorem donec massa sapien faucibus et molestie ac. Eget duis at tellus at urna condimentum mattis pellentesque id. Donec ultrices tincidunt arcu non sodales neque sodales. Eget est lorem ipsum dolor sit amet. Hendrerit gravida rutrum quisque non tellus orci ac. Ut morbi tincidunt augue interdum velit euismod. Orci dapibus ultrices in iaculis nunc sed.

''';
