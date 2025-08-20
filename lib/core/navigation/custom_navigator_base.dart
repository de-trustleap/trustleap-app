abstract class CustomNavigatorBase {
  String get currentPath;
  void navigate(String route, {Object? arguments});
  void pushNamed(String route, {Object? arguments});
  void pushAndReplace(String route, String params);
  void openInNewTab(String route);
  void openURLInNewTab(String url);
  void pop();
}