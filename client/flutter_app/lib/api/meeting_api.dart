import 'dart:convert';

import 'package:flutter_app/configs/meeting_config.dart';
import 'package:flutter_app/utils/user_utils.dart';
import 'package:http/http.dart' as http;

// String MEETING_API_URL = "http://192.168.10.212:4000/api/meeting";
String MEETING_API_URL = "http://$meetingConfigAddress:$meetingConfigPort/api/meeting";

final client = http.Client();

Future<http.Response?> startMeeting() async {
  Map<String, String> requestHeaders = {"Content-Type": "application/json"};
  final userId = await loadUuId();
  final repo = await http.post(Uri.parse("$MEETING_API_URL/start"),
      headers: requestHeaders,
      body: jsonEncode({"hostId": userId, "hostName": ""}));
  if (repo.statusCode == 200) {
    return repo;
  } else {
    return null;
  }
}

Future<http.Response?> joinMeeting({required String meetingId}) async {
  final repo = await http.get(
    Uri.parse("$MEETING_API_URL/join?meetingId=$meetingId"),
  );
  if (repo.statusCode == 200) {
    return repo;
  } else {
    throw UnsupportedError("Not a valid Meeting");
  }
}
