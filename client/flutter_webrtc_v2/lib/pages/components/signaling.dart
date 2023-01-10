import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_v2/models/socket_status_enum.dart';
import 'package:flutter_webrtc_v2/utils/device_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Map<String, dynamic> _iceServers = {
  'iceServers': [
    {'url': 'stun:stun.l.google.com:19302'},
    /*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
      */
  ]
};

class Signaling {
  final String url;
  IO.Socket? socket;
  Signaling({
    required this.url,
  });

  Future<IO.Socket?> connect() async {
    try {
      socket = await _connectForSelfSignedCert(url);
      return socket;
    } catch (e) {
      rethrow;
    }
  }

  close() {
    if (socket != null) {
      socket!
          .emit('deviceDisconnect', jsonEncode(DeviceUtils.instant.deviceInfo));
    }
  }

  Future<IO.Socket> _connectForSelfSignedCert(url) async {
    try {
      IO.Socket socket = IO.io(url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      socket.onConnect((_) {
        socket.emit(
            'deviceConnect', jsonEncode(DeviceUtils.instant.deviceInfo));
      });
      if (socket.connected == true) {
        socket.emit(
            'deviceConnect', jsonEncode(DeviceUtils.instant.deviceInfo));
      }

      return socket;
    } catch (e) {
      rethrow;
    }
  }

  sendChangeSocket({required String deviceId, required String type}) {
    try {
      if (socket!.connected == true) {
        final data = DeviceUtils.instant.deviceInfo;
        Map dataSend = {};

        switch (type) {
          case JOIN_CANCEL:
          case JOIN_RUNNING:
          case JOINED:
            dataSend["type"] = type;
            dataSend["deviceIdSender"] = data["deviceId"];
            dataSend["deviceNameSender"] = data["deviceName"];
            dataSend["deviceId"] = deviceId;
            socket!.emit("onChange", jsonEncode(dataSend));
            break;
          default:
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };
    late MediaStream stream;
    stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return stream;
  }

  createRemoteStream() async {
    // RTCPeerConnection pc = await createPeerConnection({
    //   ..._iceServers,
    //   ...{'sdpSemantics': sdpSemantics}
    // }, _config);
  }
}
