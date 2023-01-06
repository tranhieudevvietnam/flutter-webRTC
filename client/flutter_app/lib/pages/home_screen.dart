import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/meeting_api.dart';
import 'package:flutter_app/models/meeting_detail.dart';
import 'package:flutter_app/pages/join_screen.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting app"),
      ),
      body: SafeArea(
          child: Form(
        key: globalKey,
        child: Column(
          children: [
            const Text(
              "Welcome to WebRTC meeting app",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
                context, "meetingId", "Enter meeting id...", (value) {
              if (value.toString().isEmpty) {
                return "Meetin id can't be empty";
              }
              return null;
            }, (onSaved) {
              meetingId = onSaved;
            },
                borderColor: Colors.red,
                borderFocusColor: Colors.red,
                borderRadius: 10),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: FormHelper.submitButton("Join meeting", () {
                    if (validateAndSave()) {
                      validateMeeting(context: context, meetingId: meetingId);
                    }
                  }),
                ),
                Expanded(
                  child: FormHelper.submitButton("Start meeting", () async {
                    final repo = await startMeeting();
                    final body = jsonDecode(repo!.body);
                    final meetingId = body["data"];
                    validateMeeting(context: context, meetingId: meetingId);
                  }),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  validateMeeting(
      {required BuildContext context, required String meetingId}) async {
    try {
      final repo = await joinMeeting(meetingId: meetingId);
      final data = jsonDecode(repo!.body);
      final meetingDetail = MeetingDetail.fromJson(data["data"]);
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return JoinScreen(
            meetingId: meetingId,
            meetingDetail: meetingDetail,
          );
        },
      ));
      // go to join screen
    } catch (e) {
      rethrow;
      // FormHelper.showSimpleAlertDialog(
      //     context, "Meeting app", "Invalid Meeting id", "ok", () {
      //   Navigator.of(context).pop();
      // });
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
