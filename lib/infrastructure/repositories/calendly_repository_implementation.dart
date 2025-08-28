import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/repositories/calendly_repository.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CalendlyRepositoryImplementation implements CalendlyRepository {
  static const String _authUrl = "https://auth.calendly.com/oauth/authorize";
  static const String _apiBaseUrl = "https://api.calendly.com";

  final http.Client httpClient = http.Client();
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final Environment environment = Environment();

  // PKCE parameters
  String? _codeVerifier;
  String? _codeChallenge;

  CalendlyRepositoryImplementation({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<Either<DatabaseFailure, String>> getAuthorizationUrl() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return left(BackendFailure());
      }

      // Generate PKCE parameters
      _codeVerifier = _generateCodeVerifier();
      _codeChallenge = _generateCodeChallenge(_codeVerifier!);

      final redirectUri = Environment().isStaging()
          ? "https://europe-west3-trustleap-staging.cloudfunctions.net/calendlyOAuthCallback"
          : "https://europe-west3-finanzwegbegleiter.cloudfunctions.net/calendlyOAuthCallback";

      final clientId = environment.isStaging()
          ? "ikt7o3GGKmjpXS6_kL4AxzQ0b8XucPYcE-Zby_rnAAU"
          : "7loQsd5-hqQZP9NmCT7Hldw8lwOR7EgnMFeJFU0UxjY";

      final uri = Uri.parse(_authUrl).replace(queryParameters: {
        "client_id": clientId,
        "response_type": "code",
        "redirect_uri": redirectUri,
        "scope": "default",
        "state": "${user.uid}|$_codeVerifier",
        "code_challenge": _codeChallenge,
        "code_challenge_method": "S256",
      });

      return right(uri.toString());
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, Map<String, dynamic>>> getUserInfo() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return left(BackendFailure());
      }

      final docSnapshot = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("integrations")
          .doc("calendly")
          .get();

      if (!docSnapshot.exists) {
        return left(NotFoundFailure());
      }

      final data = docSnapshot.data()!;
      final userInfo = data["user"] as Map<String, dynamic>?;

      if (userInfo == null) {
        return left(BackendFailure());
      }

      return right(userInfo);
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, List<Map<String, dynamic>>>>
      getUserEventTypes() async {
    try {
      final tokenResult = await _getStoredToken();
      final userInfoResult = await getUserInfo();
      
      return tokenResult.fold(
        (failure) => left(failure),
        (token) async {
          if (token == null) {
            return left(BackendFailure());
          }
          
          return userInfoResult.fold(
            (failure) => left(failure),
            (userInfo) async {
              final userUri = userInfo["uri"] as String?;
              if (userUri == null) {
                return left(BackendFailure());
              }

              final response = await httpClient.get(
                Uri.parse("$_apiBaseUrl/event_types?user=$userUri"),
                headers: {
                  "Authorization": "Bearer $token",
                  "Content-Type": "application/json",
                },
              );

              if (response.statusCode == 200) {
                final data = json.decode(response.body) as Map<String, dynamic>;
                final eventTypes = (data["collection"] as List<dynamic>)
                    .map((item) => item as Map<String, dynamic>)
                    .toList();

                return right(eventTypes);
              } else if (response.statusCode == 401) {
                await clearAuthentication();
                return left(BackendFailure());
              } else {
                return left(BackendFailure());
              }
            },
          );
        },
      );
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, bool>> isAuthenticated() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return right(false);
      }

      final docSnapshot = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("integrations")
          .doc("calendly")
          .get();

      if (!docSnapshot.exists) {
        return right(false);
      }

      final data = docSnapshot.data()!;
      final accessToken = data["accessToken"] as String?;
      final expiresAt = data["expiresAt"] as int?;

      if (accessToken == null || expiresAt == null) {
        return right(false);
      }

      final isExpired = DateTime.now().millisecondsSinceEpoch > expiresAt;
      return right(!isExpired);
    } catch (e) {
      return left(BackendFailure());
    }
  }

  Future<Either<DatabaseFailure, String?>> _getStoredToken() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return right(null);
      }

      final docSnapshot = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("integrations")
          .doc("calendly")
          .get();

      if (!docSnapshot.exists) {
        return right(null);
      }

      final data = docSnapshot.data()!;
      final accessToken = data["accessToken"] as String?;
      final expiresAt = data["expiresAt"] as int?;

      if (accessToken == null || expiresAt == null) {
        return right(null);
      }

      // Check if token is still valid
      final isExpired = DateTime.now().millisecondsSinceEpoch > expiresAt;
      if (isExpired) {
        return right(null);
      }

      return right(accessToken);
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> clearAuthentication() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return right(unit);
      }

      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("integrations")
          .doc("calendly")
          .delete();

      return const Right(unit);
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Stream<Either<DatabaseFailure, bool>> observeAuthenticationStatus() {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return Stream.value(right(false));
    }

    return firestore
        .collection("users")
        .doc(user.uid)
        .collection("integrations")
        .doc("calendly")
        .snapshots()
        .map((snapshot) {
      try {
        if (!snapshot.exists) {
          return right(false);
        }

        final data = snapshot.data()!;
        final accessToken = data["accessToken"] as String?;
        final expiresAt = data["expiresAt"] as int?;

        if (accessToken == null || expiresAt == null) {
          return right(false);
        }

        final isExpired = DateTime.now().millisecondsSinceEpoch > expiresAt;
        return right(!isExpired);
      } on FirebaseException catch (e) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      }
    });
  }

  /// Generate a cryptographically secure random code verifier for PKCE
  String _generateCodeVerifier() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(128, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// Generate code challenge from verifier using SHA256
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
}
