import 'package:web/web.dart' as web;

class ConsentLocalStorage {
  static Future<void> initialize() async {}

  static String? getItem(String key) =>
      web.window.localStorage.getItem(key);

  static void setItem(String key, String value) =>
      web.window.localStorage.setItem(key, value);
}
