import 'package:flutter/material.dart';
import 'package:flutter_app/models/meeting_detail.dart';
import 'package:flutter_app/pages/home_screen.dart';
import 'package:flutter_app/utils/user_utils.dart';
import 'package:flutter_app/widgets/control_panel.dart';
import 'package:flutter_app/widgets/remote_connection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage(
      {super.key,
      required this.meetingId,
      this.name,
      required this.meetingDetail});

  final String meetingId;
  final String? name;
  final MeetingDetail meetingDetail;

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _locaRenderer = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {"audio": true, "video": true};
  bool isConnectionFailed = false;

  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }

  startMeeting() async {
    final String uuid = await loadUuId();
    meetingHelper = WebRTCMeetingHelper(
        url: "http://192.168.10.212:4000",
        meetingId: widget.meetingId,
        userId: uuid,
        name: widget.name);
    MediaStream localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    meetingHelper!.on("open", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("connection", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("user-left", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("video-toggle", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("audio-toggle", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("meeting-ended", context, (ev, context) {
      onMeetingEnd();
    });
    meetingHelper!.on("connection-setting-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("stream-change", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    setState(() {});
  }

  initRenderer() async {
    await _locaRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderer();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _locaRenderer.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children:
                    List.generate(meetingHelper!.connections.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: RemoteConnection(
                        renderer: meetingHelper!.connections[index].renderer,
                        connection: meetingHelper!.connections[index]),
                  );
                }),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Waiting for participants to join the meeting",
                    style: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ),
        Positioned(
            bottom: 10,
            right: 0,
            child: SizedBox(
              child: RTCVideoView(_locaRenderer),
            ))
      ],
    );
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }
}
