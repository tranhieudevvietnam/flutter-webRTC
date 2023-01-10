import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_v2/pages/components/signaling.dart';


class CallScreen extends StatefulWidget {
  final Signaling signaling;
  const CallScreen({super.key, required this.signaling});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  initState() {
    super.initState();
    initRenderers();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        MediaStream localStream = await widget.signaling.createStream();
        _localRenderer.srcObject = localStream;
        setState(() {});
      } catch (e) {
        rethrow;
      }
    });
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
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
                  child: RTCVideoView(_remoteRenderer),
                )),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height: orientation == Orientation.portrait ? 120.0 : 90.0,
                decoration: const BoxDecoration(color: Colors.black54),
                child: RTCVideoView(_localRenderer, mirror: true),
              ),
            ),
          ]),
        );
      })),
    );
  }
}
