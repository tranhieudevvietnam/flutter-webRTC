import 'package:flutter/material.dart';
import 'package:flutter_app/models/meeting_detail.dart';
import 'package:flutter_app/pages/meeting_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class JoinScreen extends StatefulWidget {
  final String meetingId;
  final MeetingDetail meetingDetail;
  const JoinScreen(
      {super.key, required this.meetingId, required this.meetingDetail});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Meeting"),
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
            FormHelper.inputFieldWidget(context, "Name", "Enter meeting id...",
                (value) {
              if (value.toString().isEmpty) {
                return "Meetin id can't be empty";
              }
              return null;
            }, (onSaved) {
              name = onSaved;
            },
                borderColor: Colors.red,
                borderFocusColor: Colors.red,
                borderRadius: 10),
            const SizedBox(
              height: 20,
            ),
            FormHelper.submitButton("Join meeting", () {
              if (validateAndSave()) {
                // validateMeeting(context: context, meetingId: meetingId);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeetingPage(
                          meetingId: widget.meetingId,
                          name: name,
                          meetingDetail: widget.meetingDetail),
                    ));
              }
            }),
          ],
        ),
      )),
    );
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
