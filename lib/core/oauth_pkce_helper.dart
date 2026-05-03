import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class OAuthPkceHelper {
  static const String _verifierChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  static String generateCodeVerifier() {
    final random = Random.secure();
    return List.generate(
            128, (_) => _verifierChars[random.nextInt(_verifierChars.length)])
        .join();
  }

  static String generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  static String generateNonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
