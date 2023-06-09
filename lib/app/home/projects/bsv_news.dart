import 'package:website/main.dart';

const _text = '''
BSV News was a hacker news clone with a unique cryptocurrency integration. Instead of upvoting, users tipped small amounts of cryptocurrency allowing posters to earn money for their contributions. The tip total was then used as a metric to rank posts on the home page.

BSV News used a novel architecture that took advantage of the low transaction fees and instant confirmations of the BSV cryptocurrency network. Instead of creating an account and authenticating on a private backend server, users broadcast their actions to the BSV mining network using a custom data encoding protocol. On the backend, these transactions were streamed from the blockchain in real time using an intermediary. These transactions were used to update persistent state in a MongoDB instance

This architecture allowed any 3rd party to be able to permissionlessly recreate the current state of BSV News and offer a competing frontend to the protocol.
''';

class BsvNews extends StatelessWidget {
  const BsvNews({super.key});

  @override
  Widget build(BuildContext context) {
    return ProjectContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                _text,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Gap(24),
            const Expanded(
              flex: 1,
              child: Column(
                children: [Placeholder(), Gap(12), Placeholder()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
