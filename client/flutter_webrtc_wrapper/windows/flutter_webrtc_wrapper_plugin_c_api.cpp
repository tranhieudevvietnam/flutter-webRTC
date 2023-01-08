#include "include/flutter_webrtc_wrapper/flutter_webrtc_wrapper_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_webrtc_wrapper_plugin.h"

void FlutterWebrtcWrapperPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_webrtc_wrapper::FlutterWebrtcWrapperPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
