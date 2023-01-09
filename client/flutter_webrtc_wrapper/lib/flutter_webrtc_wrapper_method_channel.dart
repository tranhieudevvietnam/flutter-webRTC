// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// import 'flutter_webrtc_wrapper_platform_interface.dart';

// /// An implementation of [FlutterWebrtcWrapperPlatform] that uses method channels.
// class MethodChannelFlutterWebrtcWrapper extends FlutterWebrtcWrapperPlatform {
//   /// The method channel used to interact with the native platform.
//   @visibleForTesting
//   final methodChannel = const MethodChannel('flutter_webrtc_wrapper');

//   @override
//   Future<String?> getPlatformVersion() async {
//     final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
//     return version;
//   }
// }
