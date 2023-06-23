import 'package:website/main.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: 730,
          child: Column(
            children: [
              Gap(80),
              Intro(),
              Gap(60),
              ExpandableBio(),
            ],
          ),
        ),
      ),
    );
  }
}

class Intro extends StatelessWidget {
  const Intro({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi! My name is',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              RichText(
                  text: TextSpan(
                children: [
                  const TextSpan(text: "Jonathan Aird\nand "),
                  TextSpan(
                    text: 'I build apps',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  )
                ],
                style: Theme.of(context).textTheme.displayMedium,
              )),
            ],
          ),
          const Gap(101),
          Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: 225,
                height: 225,
                child: Image.asset('assets/headshot.jpeg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableBio
    extends StatelessWidgetReprovider<HomeViewModel, ValueEmitter<bool>> {
  const ExpandableBio({super.key});

  @override
  ValueEmitter<bool> select(HomeViewModel vm) => vm.showFullBio;

  @override
  Widget reprovide(BuildContext context, showFullBio) {
    return SizedBox(
      width: 700,
      child: Column(
        children: [
          Text(
            shortBio,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: showFullBio.value
                  ? Text(
                      longBio,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : Container(
                      alignment: Alignment.topCenter,
                      height: 1,
                      width: 700,
                      child: FittedBox(
                        fit: BoxFit.none,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 700,
                          child: Text(
                            longBio,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const Gap(12),
          TextButton(
            onPressed: showFullBio.toggle,
            child: Text(
              showFullBio.value ? "Less about me" : 'More about me',
            ),
          ),
        ],
      ),
    );
  }
}
