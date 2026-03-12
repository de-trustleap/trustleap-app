import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class AppCheckInitializer {
  static Future<void> initialize({String? webToken}) async {
    if (kIsWeb && webToken != null) {
      await FirebaseAppCheck.instance.activate(
        providerWeb: ReCaptchaV3Provider(webToken),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await FirebaseAppCheck.instance.activate(
        providerApple: kDebugMode
            ? const AppleDebugProvider()
            : const AppleAppAttestProvider(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
      );
    }
  }
}
