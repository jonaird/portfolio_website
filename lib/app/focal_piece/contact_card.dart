import 'package:website/main.dart';

class ContactCardViewModel extends EmitterContainer {
  @override
  FocalPieceViewModel get parent => super.parent as FocalPieceViewModel;

  final nameField = TextEditingEmitter();
  final emailField = TextEditingEmitter();
  final messageField = TextEditingEmitter();
  late final _contactCardOpen = ValueEmitter.reactive(
    reactTo: [parent],
    withValue: () => parent.stage == FocalPieceStages.contact,
  );
  var messageSent = false;
  late final alignment = ValueEmitter.reactive(
    reactTo: [_contactCardOpen],
    withValue: () {
      if (_contactCardOpen.value) return Alignment.center;
      if (messageSent) return Alignment.topCenter;
      return Alignment.bottomCenter;
    },
  );

  sendMessage() async {
    final success = await _sendMessage();
    if (success) {
      messageSent = true;
      parent.stage = FocalPieceStages.fab;
    } else {
      // failure case
      debugPrint('failure');
    }
  }

  Future<bool> _sendMessage() {
    return Future.value(true);
    // return http.post(
    //     Uri.parse('https://hooks.zapier.com/hooks/catch/15567945/3t0c6va/'),
    //     body: {
    //       "name": nameField.text,
    //       "email": emailField.text,
    //       "message": messageField.text
    //     }).then((value) => jsonDecode(value.body)['status'] == 'success');
  }

  @override
  get children => {alignment};
}

enum ContactCardStage { inactive, active, messageSent }

class ContactCardContainer
    extends StatelessWidgetConsumer<ContactCardViewModel> {
  const ContactCardContainer({super.key});

  @override
  Widget consume(BuildContext context, vm) {
    final inputDecoration = InputDecoration(
      border: const OutlineInputBorder(),
      labelText: 'Name',
      floatingLabelStyle:
          TextStyle(color: Theme.of(context).colorScheme.secondary),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
    return OverflowBox(
      maxHeight: double.infinity,
      child: SizedBox(
        height: MediaQuery.of(context).size.height + 800,
        child: AnimatedAlign(
          alignment: vm.alignment.value,
          curve: FocalPieceViewModel.animationCurve,
          duration: const Duration(milliseconds: 400),
          child: SizedBox(
            width: 450,
            height: 400,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                child: Column(
                  children: [
                    const _CloseButton(),
                    const Gap(10),
                    TextField(
                      controller: vm.nameField,
                      decoration: inputDecoration,
                    ),
                    const Gap(8),
                    TextField(
                      controller: vm.emailField,
                      decoration: inputDecoration.copyWith(labelText: 'Email'),
                    ),
                    const Gap(8),
                    TextField(
                      controller: vm.messageField,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Message',
                      ),
                      minLines: 7,
                      maxLines: 7,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: context.appViewModel.focalPiece.content.onCloseContactCard,
        tooltip: 'Close',
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
