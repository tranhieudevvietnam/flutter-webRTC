import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/sdk/connection.dart';

class RemoteConnection extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final Connection connection;
  const RemoteConnection(
      {super.key, required this.renderer, required this.connection});

  @override
  State<RemoteConnection> createState() => _RemoteConnectionState();
}

class _RemoteConnectionState extends State<RemoteConnection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: RTCVideoView(
            widget.renderer,
            mirror: false,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
        Container(
          color: widget.connection.videoEnabled!
              ? Colors.transparent
              : Colors.blueGrey,
          child: Center(
              child: Text(
            widget.connection.videoEnabled! ? "" : widget.connection.name!,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black,
            child: Row(children: [
              Text(
                widget.connection.name!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(
                widget.connection.audioEnabled! ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 15,
              )
            ]),
          ),
        )
      ],
    );
  }
}
