import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_v2/models/device_model.dart';
import 'package:flutter_webrtc_v2/models/socket_status_enum.dart';
import 'package:flutter_webrtc_v2/pages/call_screen.dart';
import 'package:flutter_webrtc_v2/pages/components/dialog.dart';
import 'package:flutter_webrtc_v2/pages/components/session.dart';
import 'package:flutter_webrtc_v2/pages/components/signaling.dart';
import 'package:flutter_webrtc_v2/utils/device_utils.dart';

class ListDevicesScreen extends StatefulWidget {
  final String host;
  const ListDevicesScreen({super.key, required this.host});

  @override
  State<ListDevicesScreen> createState() => _ListDevicesScreenState();
}

class _ListDevicesScreenState extends State<ListDevicesScreen> {
  late Signaling signaling;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  ValueNotifier<List<DeviceModel>> listDevices = ValueNotifier([]);

  @override
  initState() {
    super.initState();
    initRenderers();

    _connect(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        MediaStream localStream = await signaling.createStream();
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
  dispose() {
    super.dispose();
  }

  void _connect(BuildContext context) async {
    var url = 'http://${widget.host}:4000';
    signaling = Signaling(
      url: url,
    );
    await signaling.connect();
    signaling.socket?.on("onDevices", (data) {
      debugPrint("onDevices-> $data");
      final dataDevices = (jsonDecode(data) as List)
          .map((e) => DeviceModel.fromJson(e))
          .toList();
      dataDevices.removeWhere(
          (element) => element.deviceId == DeviceUtils.instant.deviceId);
      listDevices.value = dataDevices;
    });
    handleOnChangeSocket();
  }

  handleOnChangeSocket() {
    signaling.socket?.on("onChange", (data) async {
      final jsonData = jsonDecode(data);
      debugPrint("onChange-> $jsonData");

      switch (jsonData["type"]) {
        case CANDIDATE:
          var sessionId = jsonData["data"]["sessionId"];
          var session = signaling.sessions[sessionId];
          final candidateMap = jsonData["data"]["description"];
          RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
              candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);

          if (session != null) {
            if (session.pc != null) {
              await session.pc?.addCandidate(candidate);
            } else {
              session.remoteCandidates.add(candidate);
            }
          } else {
            signaling.sessions[sessionId] = Session(
                peerId: jsonData["data"]["deviceIdSender"],
                sessionId: sessionId)
              ..remoteCandidates.add(candidate);
          }
          break;
        case JOIN_CANCEL:
          DialogComponent.instant.turnOffDialog();
          break;
        case JOINED:
          DialogComponent.instant.turnOffDialog();
          final sessionId = jsonData["data"]["sessionId"];
          var session = signaling.sessions[sessionId];
          session?.pc?.setRemoteDescription(RTCSessionDescription(
            jsonData["data"]["description"]['sdp'],
            jsonData["data"]["description"]['type'],
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallScreen(
                    signaling: signaling,
                    session: session!,
                    localRenderer: _localRenderer,
                    remoteRenderer: _remoteRenderer),
              ));
          break;
        case JOIN_RUNNING:
          var newSession = await signaling.createSession(
            peerId: jsonData["data"]["deviceIdSender"],
            sessionId: jsonData["data"]["sessionId"],
            streamLocal: _localRenderer.srcObject!,
            onAddRemoteStream: (mediaStream) {
              _remoteRenderer.srcObject = mediaStream;
            },
          );
          signaling.sessions[jsonData["data"]["sessionId"]] = newSession;
          await newSession.pc?.setRemoteDescription(RTCSessionDescription(
              jsonData["data"]["description"]['sdp'],
              jsonData["data"]["description"]['type']));
          if (newSession.remoteCandidates.isNotEmpty) {
            for (var candidate in newSession.remoteCandidates) {
              await newSession.pc?.addCandidate(candidate);
            }
            newSession.remoteCandidates.clear();
          }
          signaling.sessions[newSession.sessionId] = newSession;
          // ignore: use_build_context_synchronously
          DialogComponent.instant.showAcceptDialog(
              context, jsonData["data"]["deviceName"], onAccept: () {
            signaling.sendChangeSocket(
                deviceId: jsonData["data"]["deviceIdSender"],
                type: JOINED,
                param: {
                  'sdp': jsonData["data"]["description"]['sdp'],
                  'type': jsonData["data"]["description"]['type']
                });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallScreen(
                      session: newSession,
                      signaling: signaling,
                      localRenderer: _localRenderer,
                      remoteRenderer: _remoteRenderer),
                ));
          }, onReject: () {
            signaling.sendChangeSocket(
                deviceId: jsonData["data"]["deviceIdSender"],
                type: JOIN_CANCEL);
          });
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List devices"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: listDevices,
            builder: (context, value, child) {
              return Column(
                children: List.generate(
                    value.length,
                    (index) => GestureDetector(
                          onTap: () {
                            DialogComponent.instant.showInvateDialog(context,
                                onCancel: () {
                              signaling.sendChangeSocket(
                                  deviceId: value[index].deviceId!,
                                  type: JOIN_CANCEL);
                            });

                            signaling.invite(
                              value[index].deviceId!,
                              streamLocal: _localRenderer.srcObject!,
                              onAddRemoteStream: (mediaStream) {
                                _remoteRenderer.srcObject = mediaStream;
                              },
                            );
                            // signaling.sendChangeSocket(
                            //     deviceId: value[index].deviceId!,
                            //     type: JOIN_RUNNING);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.red.shade100)),
                            child: Row(
                              children: [
                                const Icon(Icons.phone_iphone_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(value[index].deviceName ?? "N/A")
                              ],
                            ),
                          ),
                        )),
              );
            },
          ))
        ],
      )),
    );
  }
}
