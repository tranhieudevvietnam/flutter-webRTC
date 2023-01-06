import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onMeetingEnd;
  final VoidCallback? onReconnect;
  const ControlPanel(
      {super.key,
      this.videoEnabled,
      this.audioEnabled,
      this.onVideoToggle,
      this.onAudioToggle,
      this.onMeetingEnd,
      this.isConnectionFailed,
      this.onReconnect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 60,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildListWidget()),
    );
  }

  buildListWidget() {
    if (isConnectionFailed == true) {
      return <Widget>[
        IconButton(
            onPressed: onVideoToggle,
            iconSize: 32,
            color: Colors.white,
            icon: Icon(
                videoEnabled == false ? Icons.videocam : Icons.videocam_off)),
        IconButton(
            onPressed: onAudioToggle,
            iconSize: 32,
            color: Colors.white,
            icon: Icon(audioEnabled == false ? Icons.mic : Icons.mic_off)),
        const SizedBox(
          width: 25,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(10)),
          child: IconButton(
              onPressed: onMeetingEnd,
              icon: const Icon(
                Icons.call_end,
                color: Colors.white,
              )),
        )
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton("Reconnect", onReconnect!,
            btnColor: Colors.red, width: 200, height: 40)
      ];
    }
  }
}
