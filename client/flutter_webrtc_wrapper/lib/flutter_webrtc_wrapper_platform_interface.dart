// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// import 'flutter_webrtc_wrapper_method_channel.dart';

// abstract class FlutterWebrtcWrapperPlatform extends PlatformInterface {
//   /// Constructs a FlutterWebrtcWrapperPlatform.
//   FlutterWebrtcWrapperPlatform() : super(token: _token);

//   static final Object _token = Object();

//   static FlutterWebrtcWrapperPlatform _instance = MethodChannelFlutterWebrtcWrapper();

//   /// The default instance of [FlutterWebrtcWrapperPlatform] to use.
//   ///
//   /// Defaults to [MethodChannelFlutterWebrtcWrapper].
//   static FlutterWebrtcWrapperPlatform get instance => _instance;

//   /// Platform-specific implementations should set this with their own
//   /// platform-specific class that extends [FlutterWebrtcWrapperPlatform] when
//   /// they register themselves.
//   static set instance(FlutterWebrtcWrapperPlatform instance) {
//     PlatformInterface.verifyToken(instance, _token);
//     _instance = instance;
//   }

//   Future<String?> getPlatformVersion() {
//     throw UnimplementedError('platformVersion() has not been implemented.');
//   }
// }
