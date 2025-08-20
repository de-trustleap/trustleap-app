import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web/web.dart' as web;

class CustomNavigatorImplementation implements CustomNavigatorBase {
  @override
  String get currentPath {
    return Modular.to.path;
  }

  @override
  void navigate(String route, {Object? arguments}) {
    Modular.to.navigate(route, arguments: arguments);
  }

  @override
  void pushNamed(String route, {Object? arguments}) {
    Modular.to.pushNamed(route, arguments: arguments);
  }

  @override
  void pushAndReplace(String route, String params) {
    Modular.to.popUntil((route) => route.isFirst);
    Modular.to.pushNamed(route + params);
  }

  @override
  void openInNewTab(String route) {
    final url = '${web.window.location.origin}$route';
    web.window.open(url, '_blank');
  }

  @override
  void openURLInNewTab(String url) {
    web.window.open(url, '_blank');
  }

  @override
  void pop() {
    Modular.to.pop();
  }
}