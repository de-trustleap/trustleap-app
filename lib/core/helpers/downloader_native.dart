import 'package:url_launcher/url_launcher.dart';

class Downloader {
  void showFileInNewTab(String url) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
