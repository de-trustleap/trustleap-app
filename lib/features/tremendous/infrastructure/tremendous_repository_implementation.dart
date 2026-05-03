import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/cloud_functions_service.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/core/oauth_pkce_helper.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_funding_source.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_organization.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_product.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TremendousRepositoryImplementation implements TremendousRepository {
  // TODO: Replace with actual client IDs from Tremendous dashboard after sandbox app registration
  static const String _clientIdStaging =
      "R1dAlmTOmxbdtAipTFwHbz5qGH74Zotge8GXHs_PcsE";
  static const String _clientIdProd = "TREMENDOUS_CLIENT_ID_PROD_PLACEHOLDER";

  static const String _authUrlSandbox =
      "https://testflight.tremendous.com/oauth/authorize";
  static const String _authUrlProd =
      "https://api.tremendous.com/oauth/authorize";

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseFunctions firebaseFunctions;
  final CloudFunctionsService cloudFunctions;
  final Environment environment = Environment();

  TremendousRepositoryImplementation({
    required this.firestore,
    required this.firebaseAuth,
    required this.firebaseFunctions,
    required this.cloudFunctions,
  });

  @override
  Future<Either<DatabaseFailure, String>> getAuthorizationUrl() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return left(BackendFailure());

      final codeVerifier = OAuthPkceHelper.generateCodeVerifier();
      final codeChallenge = OAuthPkceHelper.generateCodeChallenge(codeVerifier);
      final nonce = OAuthPkceHelper.generateNonce();

      await firestore
          .collection("tremendousOauthStates")
          .doc(nonce)
          .set({
        "uid": user.uid,
        "verifier": codeVerifier,
        "createdAt": FieldValue.serverTimestamp(),
      });

      final redirectUri =
          "${environment.getCloudFunctionsBaseURL()}/tremendousOAuthCallback";

      final clientId =
          environment.isStaging() ? _clientIdStaging : _clientIdProd;
      final authUrl = environment.isStaging() ? _authUrlSandbox : _authUrlProd;

      final uri = Uri.parse(authUrl).replace(queryParameters: {
        "client_id": clientId,
        "response_type": "code",
        "redirect_uri": redirectUri,
        "state": nonce,
        "code_challenge": codeChallenge,
        "code_challenge_method": "S256",
      });

      return right(uri.toString());
    } catch (_) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, bool>> isConnected() async {
    try {
      final token = await _getValidToken();
      return right(token != null);
    } catch (_) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, TremendousOrganization?>>
      getOrganization() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return right(null);

      final doc = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("integrations")
          .doc("tremendous")
          .get();

      if (!doc.exists) return right(null);

      final data = doc.data()!;
      final orgMap = data["organization"] as Map<String, dynamic>?;
      final org =
          orgMap != null ? TremendousOrganization.fromMap(orgMap) : null;
      return right(org);
    } catch (_) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> disconnect() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return right(unit);

      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("integrations")
          .doc("tremendous")
          .delete();

      return right(unit);
    } catch (_) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> refreshToken() async {
    try {
      final callable =
          firebaseFunctions.httpsCallable("tremendousRefreshToken");
      await callable.call();
      return right(unit);
    } catch (_) {
      return left(BackendFailure());
    }
  }

  @override
  Stream<Either<DatabaseFailure, bool>> observeConnectionStatus() {
    final user = firebaseAuth.currentUser;
    if (user == null) return Stream.value(right(false));

    return firestore
        .collection("users")
        .doc(user.uid)
        .collection("integrations")
        .doc("tremendous")
        .snapshots()
        .asyncMap((snapshot) async {
      try {
        if (!snapshot.exists) return right(false);

        final data = snapshot.data()!;
        final accessToken = data["accessToken"] as String?;
        final expiresAt = data["expiresAt"] as int?;

        if (accessToken == null || expiresAt == null) return right(false);

        final now = DateTime.now().millisecondsSinceEpoch;
        final isExpired = now > (expiresAt - 5 * 60 * 1000);

        if (isExpired) {
          unawaited(refreshToken());
          return right(false);
        }

        return right(true);
      } on FirebaseException catch (e) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      }
    });
  }

  Future<String?> _getValidToken() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await firestore
        .collection("users")
        .doc(user.uid)
        .collection("integrations")
        .doc("tremendous")
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    final accessToken = data["accessToken"] as String?;
    final expiresAt = data["expiresAt"] as int?;

    if (accessToken == null || expiresAt == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now > (expiresAt - 5 * 60 * 1000)) return null;

    return accessToken;
  }

  @override
  Future<Either<DatabaseFailure, List<TremendousProduct>>>
      getProductList() async {
    return cloudFunctions.call(
      "tremendousListProducts",
      {},
      (data) => List<Map<String, dynamic>>.from(data['products'] as List)
          .map(TremendousProduct.fromMap)
          .toList(),
    );
  }

  @override
  Future<Either<DatabaseFailure, List<TremendousFundingSource>>>
      getFundingSourcesList() async {
    return cloudFunctions.call(
      "tremendousListFundingSources",
      {},
      (data) => List<Map<String, dynamic>>.from(data['fundingSources'] as List)
          .map(TremendousFundingSource.fromMap)
          .toList(),
    );
  }
}
