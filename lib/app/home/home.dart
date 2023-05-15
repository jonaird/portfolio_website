import 'package:website/main.dart';
import './projects/projects.dart';

const _textColor = Color(0xFFCFD8DC);

class HomePage extends ConsumerStatelessWidget<AppViewModel> {
  const HomePage({super.key});

  @override
  Widget consume(BuildContext context, vm) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        fit: BoxFit.none,
        alignment: Alignment.center,
        child: SizedBox(
          width: context.windowSize.width,
          height: context.windowSize.height + 1000,
          child: ListView(
            physics: vm.destination.value == Destinations.home
                ? null
                : const NeverScrollableScrollPhysics(),
            children: const [
              Gap(500),
              Bio(),
              Gap(48),
              Projects(),
              Gap(648),
            ],
          ),
        ),
      ),
    );
  }
}

const _shortBio =
    "I’m from Chicago but I live in Hungary with my wife and 2 year old son. I’m a full stack developer, Flutter specialist and product designer.";

const _longBio =
    "\nIn 2018 I dropped out of a math degree at Roosevelt University to persue a startup at the intersection of cryptocurrency and social media. I taught myself how to code, graduated from the Founder Institute, raised a venture funding round, hired a developer and released a product to market. Unfortunately, due to extenuating circumstances, I had to shut the company down in July 2022. After taking a much-needed sabbatical, I’m excited to reenter the workforce!";

class Bio extends StatelessWidget {
  const Bio({super.key});

  @override
  Widget build(BuildContext context) {
    return Reprovider<AppViewModel, ValueEmitter<bool>>(
        selector: (AppViewModel vm) => vm.showFullBio,
        builder: (context, showFullBio) {
          return Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 730,
              child: Column(
                children: [
                  const Gap(80),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hi! My name is\nJonathan Aird \nand I build apps',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const Gap(24),
                      Container(width: 225, height: 225, color: Colors.grey),
                    ],
                  ),
                  const Gap(24),
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
                              width: 730,
                              child: FittedBox(
                                fit: BoxFit.none,
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: 730,
                                  child: Text(
                                    _longBio,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  OutlinedButton(
                      onPressed: showFullBio.toggle,
                      child: Text(showFullBio.value
                          ? "Less about me"
                          : 'More about me'))
                ],
              ),
            ),
          );
        });
  }
}
