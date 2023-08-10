import 'package:flutter/foundation.dart';
import 'package:website/main.dart';

class ContactMeViewModel extends EmitterContainer {
  ContactMeViewModel() {
    focusNodes.forEach((key, value) {
      value.addListener(() {
        if (value.hasFocus) onFieldFocus();
      });
    });
  }

  final nameField = TextEditingEmitter();
  final emailField = TextEditingEmitter();
  final messageField = TextEditingEmitter();
  late final focusNodes = [nameField, emailField, messageField]
      .asMap()
      .map((key, value) => MapEntry(value, FocusNode()));

  final somethingWentWrong = ValueEmitter(false);
  var messageSent = false;
  var duration = const Duration(milliseconds: 400);

  void onFieldFocus() {
    findAncestorOfExactType<AppViewModel>()!.goToContactMeSection();
  }

  Future<bool> sendMessage() async {
    final success = await _sendMessage();
    if (success) {
      messageSent = true;
      // parent.stage = FocalPieceStages.fab;
      findAncestorOfExactType<AppViewModel>()!
          .showSnackBar('Message sent! I will get back to you shortly!');
      return true;
    } else {
      somethingWentWrong.value = true;
      return false;
    }
  }

  Future<bool> _sendMessage() {
    if (kDebugMode) {
      return Future.delayed(const Duration(milliseconds: 600), () => true);
    }
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
  get children => {somethingWentWrong};
}

enum ContactCardStage { inactive, active, messageSent }

class ContactMeSection extends StatelessWidgetConsumer<ContactMeViewModel> {
  const ContactMeSection({
    super.key,
  });

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
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 500,
        // height: 400,
        child: Card(
          color: Theme.of(context).colorScheme.background,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                const Gap(24),
                TextField(
                  controller: vm.nameField,
                  decoration: inputDecoration,
                  focusNode: vm.focusNodes[vm.nameField],
                ),
                const Gap(12),
                TextField(
                  controller: vm.emailField,
                  decoration: inputDecoration.copyWith(labelText: 'Email'),
                  focusNode: vm.focusNodes[vm.emailField],
                ),
                const Gap(12),
                TextField(
                  controller: vm.messageField,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Message',
                  ),
                  minLines: 7,
                  maxLines: 7,
                  focusNode: vm.focusNodes[vm.messageField],
                ),
                const Gap(12),
                if (vm.somethingWentWrong.value)
                  const SelectableText(
                    'Oops something went wrong!\nYou can contact me at jonathan.aird@gmail.com',
                    style: TextStyle(fontSize: 13),
                  ),
                const Gap(36)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(
            'Contact Me',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        // _CloseButton()
      ],
    );
  }
}
