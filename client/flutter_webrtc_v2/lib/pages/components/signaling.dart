import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_v2/models/socket_status_enum.dart';
import 'package:flutter_webrtc_v2/utils/device_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'session.dart';

Map<String, dynamic> _iceServers = {
  'iceServers': [
    // {'url': 'stun:stun.l.google.com:19302'},
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
String get sdpSemantics => 'unified-plan';

final Map<String, dynamic> _config = {
  'mandatory': {},
  'optional': [
    {'DtlsSrtpKeyAgreement': true},
  ]
};

class Signaling {
  final String url;
  IO.Socket? socket;
  Signaling({
    required this.url,
  });

  final List<MediaStream> _remoteStreams = <MediaStream>[];
  final List<RTCRtpSender> _senders = <RTCRtpSender>[];
  final Map<String, Session> sessions = {};

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

  sendChangeSocket(
      {required String deviceId,
      required String type,
      Map<String, dynamic>? param}) {
    try {
      if (socket!.connected == true) {
        final data = DeviceUtils.instant.deviceInfo;
        Map dataSend = {};

        switch (type) {
          case CANDIDATE:
          case JOIN_CANCEL:
          case JOIN_RUNNING:
          case JOINED:
            if (param != null) {
              dataSend["description"] = jsonEncode({
                "candidate": param["candidate"] ?? "",
                "sdpMid": param["sdpMid"] ?? "",
                "sdpMLineIndex": param["sdpMLineIndex"] ?? 0
              }..addAll(param));
            }
            dataSend["typeSocketStatus"] = type;
            dataSend["deviceIdSender"] = data["deviceId"];
            dataSend["deviceNameSender"] = data["deviceName"];
            dataSend["deviceId"] = deviceId;
            break;
          default:
        }
        socket!.emit("onChange", jsonEncode(dataSend));
      }
    } catch (e) {
      rethrow;
    }
  }

  void invite(
    String deviceId, {
    required MediaStream streamLocal,
    required Function(MediaStream mediaStream) onAddRemoteStream,
  }) async {
    final data = DeviceUtils.instant.deviceInfo;
    var sessionId = data["deviceId"] + '-' + deviceId;
    Session session = await createSession(
        peerId: deviceId,
        sessionId: sessionId,
        streamLocal: streamLocal,
        onAddRemoteStream: onAddRemoteStream);
    sessions[sessionId] = session;

    _createOffer(session);
  }

  Future<void> _createOffer(Session session) async {
    try {
      RTCSessionDescription s = await session.pc!.createOffer({});
      await session.pc!.setLocalDescription(_fixSdp(s));
      // _send('offer', {
      //   'to': session.pid,
      //   'from': _selfId,
      //   'description': {'sdp': s.sdp, 'type': s.type},
      //   'session_id': session.sid,
      //   'media': media,
      // });
      sendChangeSocket(
          deviceId: session.peerId,
          type: JOIN_RUNNING,
          param: {'sdp': s.sdp, 'type': s.type});
    } catch (e) {
      print(e.toString());
    }
  }

  RTCSessionDescription _fixSdp(RTCSessionDescription s) {
    var sdp = s.sdp;
    s.sdp =
        sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
    return s;
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

  Future<Session> createSession(
      {required String sessionId,
      required String peerId,
      required MediaStream streamLocal,
      required Function(MediaStream mediaStream) onAddRemoteStream}) async {
    var newSession = Session(sessionId: sessionId, peerId: peerId);

    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);

    switch (sdpSemantics) {
      case 'plan-b':
        pc.onAddStream = (MediaStream stream) {
          onAddRemoteStream.call(stream);
          _remoteStreams.add(stream);
        };
        await pc.addStream(streamLocal);
        break;
      case 'unified-plan':
        // Unified-Plan
        pc.onTrack = (event) {
          if (event.track.kind == 'video') {
            onAddRemoteStream.call(event.streams[0]);
          }
        };
        streamLocal.getTracks().forEach((track) async {
          _senders.add(await pc.addTrack(track, streamLocal));
        });
        break;
    }

    pc.onIceCandidate = (candidate) async {
      if (candidate == null) {
        print('onIceCandidate: complete!');
        return;
      }

      debugPrint("pc.onIceCandidate: ${jsonEncode({
            'sdpMLineIndex': candidate.sdpMLineIndex,
            'sdpMid': candidate.sdpMid,
            'candidate': candidate.candidate,
          })}");

      // This delay is needed to allow enough time to try an ICE candidate
      // before skipping to the next one. 1 second is just an heuristic value
      // and should be thoroughly tested in your own environment.
      await Future.delayed(const Duration(seconds: 10), () {
        sendChangeSocket(deviceId: peerId, type: CANDIDATE, param: {
          'sdpMLineIndex': candidate.sdpMLineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        });
      });
    };

    pc.onIceConnectionState = (state) {};

    pc.onRemoveStream = (stream) {
      // onRemoveRemoteStream?.call(newSession, stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc.onDataChannel = (channel) {
      // _addDataChannel(newSession, channel);
    };

    newSession.pc = pc;
    return newSession;
  }
}
