
import 'flutter_webrtc_wrapper_platform_interface.dart';

class FlutterWebrtcWrapper {
  Future<String?> getPlatformVersion() {
    return FlutterWebrtcWrapperPlatform.instance.getPlatformVersion();
  }
}
