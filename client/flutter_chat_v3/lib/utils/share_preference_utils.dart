import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceUtils {
  SharePreferenceUtils._();
  static late SharedPreferences pref;

  static init() async {
    pref = await SharedPreferences.getInstance();
  }
}
