import 'package:website/main.dart';

const _shortBio =
    "I’m from Chicago and I live in Hungary with my wife and 2 year old son. I’m a full stack developer, Flutter specialist and product designer.";

const _longBio =
    "\nIn 2018 I dropped out of a math degree at Roosevelt University to persue a startup at the intersection of cryptocurrency and social media. I taught myself how to code, graduated from the Founder Institute, raised a venture funding round, hired a developer and released a product to market. Unfortunately, due to extenuating circumstances, I had to shut the company down in July 2022. After taking a much-needed sabbatical, I’m excited to reenter the workforce!";

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
            _shortBio,
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
                      _longBio,
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
                            _longBio,
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
