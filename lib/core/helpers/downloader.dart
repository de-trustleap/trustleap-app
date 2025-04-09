import 'package:universal_html/html.dart' as html;

class Downloader {
  void showFileInNewTab(String url) {
    html.AnchorElement(href: url)
      ..target = '_blank'
      ..click();
  }
}
