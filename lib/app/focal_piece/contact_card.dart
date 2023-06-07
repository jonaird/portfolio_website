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
  final somethingWentWrong = ValueEmitter(false);
  var messageSent = false;
  var duration = const Duration(milliseconds: 400);

  Alignment get alignment {
    if (_contactCardOpen.value) return Alignment.center;
    if (messageSent) return Alignment.topCenter;
    return Alignment.bottomCenter;
  }

  sendMessage() async {
    final success = await _sendMessage();
    if (success) {
      messageSent = true;
      parent.stage = FocalPieceStages.fab;
      findAncestorOfExactType<AppViewModel>()!
          .showSnackBarMessage('Message sent! I will get back to you shortly!');
    } else {
      somethingWentWrong.value = true;
    }
  }

  void close() {
    parent.stage = FocalPieceStages.fab;
  }

  void finishedAnimating() {
    if (duration == Duration.zero) {
      duration = const Duration(milliseconds: 400);
    }
    if (!_contactCardOpen.value) {
      somethingWentWrong.value = false;
      for (var element in [nameField, emailField, messageField]) {
        element.clear();
      }
      if (messageSent) {
        messageSent = false;
        duration = Duration.zero;
        emit();
      }
    }
  }

  Future<bool> _sendMessage() {
    // return Future.delayed(const Duration(milliseconds: 600), () => true);
    return post(
        Uri.parse(
            'https://connect.pabbly.com/workflow/sendwebhookdata/IjU3NjUwNTZkMDYzNTA0M2M1MjZkNTUzNTUxMzUi_pc'),
        body: {
          "name": nameField.text,
          "email": emailField.text,
          "message": messageField.text
        }).then((value) {
      return jsonDecode(value.body)['status'] == 'success';
    });
  }

  @override
  get children => {_contactCardOpen, somethingWentWrong};
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
          alignment: vm.alignment,
          onEnd: vm.finishedAnimating,
          curve: FocalPieceViewModel.animationCurve,
          duration: vm.duration,
          child: SizedBox(
            width: 450,
            height: 400,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Gap(12),
                    if (vm.somethingWentWrong.value)
                      const SelectableText(
                          'Oops something went wrong!\nYou can contact me at jonathan.aird@gmail.com')
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
        onPressed: context.read<ContactCardViewModel>()!.close,
        tooltip: 'Close',
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
