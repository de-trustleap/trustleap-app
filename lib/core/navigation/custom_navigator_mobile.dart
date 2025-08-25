import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // On mobile, we can't open in new tab, so we navigate normally
    // or could use url_launcher to open in external browser
    navigate(route);
  }

  @override
  void openURLInNewTab(String url) async {
    // On mobile, open in external browser
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void pop() {
    Modular.to.pop();
  }
}
