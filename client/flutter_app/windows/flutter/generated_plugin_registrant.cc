//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <flutter_webrtc_wrapper/flutter_webrtc_wrapper_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterWebRTCPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebRTCPlugin"));
  FlutterWebrtcWrapperPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebrtcWrapperPluginCApi"));
}
