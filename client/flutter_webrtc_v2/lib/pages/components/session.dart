
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Session {
  Session({required this.sessionId, required this.peerId});
  String peerId;
  String sessionId;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
}