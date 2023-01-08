import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper_platform_interface.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWebrtcWrapperPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWebrtcWrapperPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterWebrtcWrapperPlatform initialPlatform = FlutterWebrtcWrapperPlatform.instance;

  test('$MethodChannelFlutterWebrtcWrapper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWebrtcWrapper>());
  });

  test('getPlatformVersion', () async {
    FlutterWebrtcWrapper flutterWebrtcWrapperPlugin = FlutterWebrtcWrapper();
    MockFlutterWebrtcWrapperPlatform fakePlatform = MockFlutterWebrtcWrapperPlatform();
    FlutterWebrtcWrapperPlatform.instance = fakePlatform;

    expect(await flutterWebrtcWrapperPlugin.getPlatformVersion(), '42');
  });
}
