import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper_method_channel.dart';

void main() {
  MethodChannelFlutterWebrtcWrapper platform = MethodChannelFlutterWebrtcWrapper();
  const MethodChannel channel = MethodChannel('flutter_webrtc_wrapper');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
