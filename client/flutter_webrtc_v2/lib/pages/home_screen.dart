import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'list_devices_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String hostIp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebRTC app"),
      ),
      body: SafeArea(
          child: Form(
        key: globalKey,
        child: Column(
          children: [
            const Text(
              "Welcome to WebRTC app",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(context, "hostIp", "Enter host ip...",
                (value) {
              if (value.toString().isEmpty) {
                return "Host ip can't be empty";
              }
              return null;
            }, (onSaved) {
              hostIp = onSaved;
            },
                borderColor: Colors.red,
                borderFocusColor: Colors.red,
                borderRadius: 10),
            const SizedBox(
              height: 20,
            ),
            FormHelper.submitButton("Start", () {
              if (validateAndSave()) {
                validateMeeting(context: context, host: hostIp);
              }
            })
          ],
        ),
      )),
    );
  }

  validateMeeting({required BuildContext context, required String host}) async {
    try {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return ListDevicesScreen(
            host: host,
          );
        },
      ));
      // go to join screen
    } catch (e) {
      // rethrow;
      FormHelper.showSimpleAlertDialog(
          context, "WebRTC app", "Invalid host id", "ok", () {
        Navigator.of(context).pop();
      });
    }
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
