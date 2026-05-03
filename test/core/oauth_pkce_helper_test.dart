import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/oauth_pkce_helper.dart';

void main() {
  const _verifierChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
  final _base64UrlChars = RegExp(r'^[A-Za-z0-9\-_]+$');

  group('OAuthPkceHelper generateCodeVerifier', () {
    test('should have length 128', () {
      final verifier = OAuthPkceHelper.generateCodeVerifier();
      expect(verifier.length, equals(128));
    });

    test('should only contain allowed PKCE verifier chars', () {
      final verifier = OAuthPkceHelper.generateCodeVerifier();
      for (final char in verifier.split('')) {
        expect(_verifierChars.contains(char), isTrue,
            reason: 'Unexpected char: $char');
      }
    });

    test('should not contain padding =', () {
      final verifier = OAuthPkceHelper.generateCodeVerifier();
      expect(verifier.contains('='), isFalse);
    });

    test('should produce different values on each call', () {
      final a = OAuthPkceHelper.generateCodeVerifier();
      final b = OAuthPkceHelper.generateCodeVerifier();
      expect(a, isNot(equals(b)));
    });
  });

  group('OAuthPkceHelper generateCodeChallenge', () {
    test('should be deterministic for same verifier', () {
      const verifier = 'testVerifier123';
      final a = OAuthPkceHelper.generateCodeChallenge(verifier);
      final b = OAuthPkceHelper.generateCodeChallenge(verifier);
      expect(a, equals(b));
    });

    test('should produce different challenges for different verifiers', () {
      final a = OAuthPkceHelper.generateCodeChallenge('verifierA');
      final b = OAuthPkceHelper.generateCodeChallenge('verifierB');
      expect(a, isNot(equals(b)));
    });

    test('should not contain padding =', () {
      final challenge =
          OAuthPkceHelper.generateCodeChallenge('anyVerifier');
      expect(challenge.contains('='), isFalse);
    });

    test('should only contain base64url chars', () {
      final challenge =
          OAuthPkceHelper.generateCodeChallenge('anyVerifier');
      expect(_base64UrlChars.hasMatch(challenge), isTrue);
    });

    test('should match known SHA256 base64url result for "abc"', () {
      // SHA256("abc") = ba7816bf...  base64url without padding
      const expected = 'ungWv48Bz-pBQUDeXa4iI7ADYaOWF3qctBD_YfIAFa0';
      expect(OAuthPkceHelper.generateCodeChallenge('abc'), equals(expected));
    });

    test('should produce 43-char challenge for any verifier', () {
      // SHA256 = 32 bytes → base64url always 43 chars (no padding)
      final verifier = OAuthPkceHelper.generateCodeVerifier();
      final challenge = OAuthPkceHelper.generateCodeChallenge(verifier);
      expect(challenge.length, equals(43));
    });
  });

  group('OAuthPkceHelper generateNonce', () {
    test('should not contain padding =', () {
      final nonce = OAuthPkceHelper.generateNonce();
      expect(nonce.contains('='), isFalse);
    });

    test('should only contain base64url chars', () {
      final nonce = OAuthPkceHelper.generateNonce();
      expect(_base64UrlChars.hasMatch(nonce), isTrue);
    });

    test('should produce different values on each call', () {
      final a = OAuthPkceHelper.generateNonce();
      final b = OAuthPkceHelper.generateNonce();
      expect(a, isNot(equals(b)));
    });

    test('should have length 43 (32 bytes base64url without padding)', () {
      // 32 bytes → ceil(32/3)*4 = 44 chars with padding → 43 without =
      final nonce = OAuthPkceHelper.generateNonce();
      expect(nonce.length, equals(43));
    });
  });
}
