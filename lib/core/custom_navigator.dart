import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:universal_html/html.dart' as html;

class CustomNavigator {
  static String get currentPath {
    return Modular.to.path;
  }

  static void navigate(String route, {Object? arguments}) {
    Modular.to.navigate(route, arguments: arguments);
  }

  static void pushNamed(String route, {Object? arguments}) {
    Modular.to.pushNamed(route, arguments: arguments);
  }

  static void pushAndReplace(String route, String params) {
    Modular.to.popUntil((route) => route.isFirst);
    Modular.to.pushNamed(route + params);
  }

  static void openInNewTab(String route) {
    if (kIsWeb) {
      final url = '${html.window.location.origin}$route';
      html.window.open(url, '_blank');
    }
  }

  static void pop() {
    Modular.to.pop();
  }
}
