import 'package:flutter/material.dart';

class DialogComponent {
  BuildContext? context;
  DialogComponent._();
  static final DialogComponent instant = DialogComponent._();

  turnOffDialog() {
    if (context != null) {
      Navigator.pop(context!);
      context = null;
    }
  }

  Future<bool?> showInvateDialog(BuildContext context, {Function? onCancel}) {
    this.context = context;
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Calling"),
          content: const Text("waiting"),
          actions: <Widget>[
            TextButton(
              child: const Text("cancel"),
              onPressed: () {
                DialogComponent.instant.turnOffDialog();

                onCancel?.call();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showAcceptDialog(BuildContext context, String deviceName,
      {Function? onReject, Function? onAccept}) {
    this.context = context;
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$deviceName call you"),
          content: const Text("accept?"),
          actions: <Widget>[
            MaterialButton(
              child: const Text(
                'Reject',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onReject?.call();
              },
            ),
            MaterialButton(
              child: const Text(
                'Accept',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                DialogComponent.instant.turnOffDialog();

                onAccept?.call();
              },
            ),
          ],
        );
      },
    );
  }
}
