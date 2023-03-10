#import "FlutterWebrtcWrapperPlugin.h"
#if __has_include(<flutter_webrtc_wrapper/flutter_webrtc_wrapper-Swift.h>)
#import <flutter_webrtc_wrapper/flutter_webrtc_wrapper-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_webrtc_wrapper-Swift.h"
#endif

@implementation FlutterWebrtcWrapperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWebrtcWrapperPlugin registerWithRegistrar:registrar];
}
@end
