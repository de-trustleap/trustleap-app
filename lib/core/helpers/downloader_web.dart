import 'package:web/web.dart' as web;

class Downloader {
  void showFileInNewTab(String url) {
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.target = '_blank';
    anchor.click();
  }
}
