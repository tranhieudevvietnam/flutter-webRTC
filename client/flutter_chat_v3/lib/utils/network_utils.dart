// ignore: depend_on_referenced_packages
import 'package:network_info_plus/network_info_plus.dart';

class NetWorkUtils {
  late NetworkInfo info;
  // ignore: unused_field
  String? _wifiIP;

  NetWorkUtils();

  static final NetWorkUtils instant = NetWorkUtils();

  init() async {
    info = NetworkInfo();
    _wifiIP = await info.getWifiIP();
  }

  String get wifiIP => _wifiIP ?? "0.0.0.0";
}
