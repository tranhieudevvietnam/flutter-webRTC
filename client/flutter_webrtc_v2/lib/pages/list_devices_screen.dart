import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_v2/models/device_model.dart';
import 'package:flutter_webrtc_v2/models/socket_status_enum.dart';
import 'package:flutter_webrtc_v2/pages/call_screen.dart';
import 'package:flutter_webrtc_v2/pages/components/dialog.dart';
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

  ValueNotifier<List<DeviceModel>> listDevices = ValueNotifier([]);

  @override
  initState() {
    super.initState();
    _connect(context);
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
    signaling.socket?.on("onChange", (data) {
      final jsonData = jsonDecode(data);
      debugPrint("onChange-> $jsonData");

      switch (jsonData["type"]) {
        case JOIN_CANCEL:
          DialogComponent.instant.turnOffDialog();
          break;
        case JOINED:
          DialogComponent.instant.turnOffDialog();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallScreen(signaling: signaling),
              ));
          break;
        case JOIN_RUNNING:
          DialogComponent.instant.showAcceptDialog(
              context, jsonData["data"]["deviceName"], onAccept: () {
            signaling.sendChangeSocket(
                deviceId: jsonData["data"]["deviceIdSender"], type: JOINED);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallScreen(signaling: signaling),
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
                            signaling.sendChangeSocket(
                                deviceId: value[index].deviceId!,
                                type: JOIN_RUNNING);
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
