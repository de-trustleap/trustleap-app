import 'package:web/web.dart' as web;

class BrowserLocation {
  static String hostname() => web.window.location.hostname;
  static String pathname() => web.window.location.pathname;
  static String search() => web.window.location.search;
}
