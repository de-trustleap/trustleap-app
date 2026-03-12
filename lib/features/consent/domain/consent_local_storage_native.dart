import 'package:shared_preferences/shared_preferences.dart';

class ConsentLocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getItem(String key) => _prefs?.getString(key);

  static void setItem(String key, String value) {
    _prefs?.setString(key, value);
  }
}
