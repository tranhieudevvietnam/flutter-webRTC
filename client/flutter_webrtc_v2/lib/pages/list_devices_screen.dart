import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_v2/apis/api_connect.dart';

class ListDevicesScreen extends StatefulWidget {
  final String host;
  const ListDevicesScreen({super.key, required this.host});

  @override
  State<ListDevicesScreen> createState() => _ListDevicesScreenState();
}

class _ListDevicesScreenState extends State<ListDevicesScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  
  @override
  initState() {
    super.initState();
    initRenderers();
    _connect(context);
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }
  void _connect(BuildContext context) {
    var url = 'http://${widget.host}:4000';

    final socket= ApiConnect(url);

    socket.connect();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List devices"),
      ),
      body: SafeArea(
          child: Column(
        children: const [],
      )),
    );
  }
  
}
