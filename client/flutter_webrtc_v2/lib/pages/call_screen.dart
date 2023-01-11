import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_v2/pages/components/session.dart';
import 'package:flutter_webrtc_v2/pages/components/signaling.dart';

class CallScreen extends StatefulWidget {
  final Signaling signaling;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final Session session;
  const CallScreen(
      {super.key,
      required this.signaling,
      required this.localRenderer,
      required this.remoteRenderer,
      required this.session});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Call Screen")),
      body: SafeArea(child: OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: RTCVideoView(widget.remoteRenderer),
                )),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height: orientation == Orientation.portrait ? 120.0 : 90.0,
                decoration: const BoxDecoration(color: Colors.black54),
                child: RTCVideoView(widget.localRenderer, mirror: true),
              ),
            ),
          ]),
        );
      })),
    );
  }
}
