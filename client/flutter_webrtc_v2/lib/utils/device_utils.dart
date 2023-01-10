import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceUtils {
  final deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceInfo = {};
  static final DeviceUtils instant = DeviceUtils._();
  DeviceUtils._();

  init() async {
    final info = (await deviceInfoPlugin.deviceInfo).toMap();
    if (Platform.isAndroid) {
      deviceInfo["deviceName"] = info["device"];
      deviceInfo["deviceId"] = info["id"];
      deviceInfo["model"] = info["model"];
    }
    if (Platform.isIOS) {
      deviceInfo["deviceName"] = info["name"];
      deviceInfo["deviceId"] = info["identifierForVendor"];
      deviceInfo["model"] = info["model"];
    }
    debugPrint("deviceInfo: $deviceInfo");
  }

  String get deviceName => deviceInfo["deviceName"];
  String get deviceId => deviceInfo["deviceId"];
  String get deviceModel => deviceInfo["model"];
}
