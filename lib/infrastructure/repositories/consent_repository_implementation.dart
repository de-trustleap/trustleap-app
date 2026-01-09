import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/consent_preference.dart';
import 'package:finanzbegleiter/domain/repositories/consent_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/consent_preference_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:web/web.dart' as web;

class ConsentRepositoryImplementation implements ConsentRepository {
  static const String _localStorageConsentKey = 'cookie_consent_preferences';
  static const String _localStorageLogKey = 'cookie_consent_log';
  static const String _localStorageSessionIdKey = 'cookie_consent_session_id';

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ConsentRepositoryImplementation({
    required this.firestore,
    required this.auth,
  });

  @override
  bool hasConsentDecision() {
    if (!kIsWeb) return true;
    return web.window.localStorage.getItem(_localStorageConsentKey) != null;
  }

  @override
  ConsentPreference getConsentPreferences() {
    if (!kIsWeb) {
      return ConsentPreference.acceptAll('1.0');
    }

    final stored = web.window.localStorage.getItem(_localStorageConsentKey);

    if (stored == null) {
      return ConsentPreference.initial();
    }

    try {
      final Map<String, dynamic> json = jsonDecode(stored);
      final preference = ConsentPreferenceModel.fromMap(json).toDomain();
      return preference;
    } catch (e) {
      return ConsentPreference.initial();
    }
  }

  @override
  bool hasConsent(ConsentCategory category) {
    if (category == ConsentCategory.necessary) {
      return true;
    }
    return getConsentPreferences().hasConsent(category);
  }

  @override
  Future<Either<DatabaseFailure, Unit>> saveConsentPreference(
    ConsentPreference preference,
  ) async {
    try {
      if (!kIsWeb) return right(unit);

      final model = ConsentPreferenceModel.fromDomain(preference);
      final jsonString = jsonEncode(model.toStorageMap());

      web.window.localStorage.setItem(_localStorageConsentKey, jsonString);
      web.window.localStorage.setItem(_localStorageLogKey, jsonString);

      await _logToFirestore(preference);

      return right(unit);
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> revokeConsent(
    String policyVersion,
  ) async {
    try {
      if (!kIsWeb) return right(unit);

      final preference = ConsentPreference.rejectAll(policyVersion);
      return await saveConsentPreference(preference);
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  bool isConsentOutdated(String currentPolicyVersion) {
    final preference = getConsentPreferences();
    return preference.policyVersion != currentPolicyVersion;
  }

  Future<void> _logToFirestore(ConsentPreference preference) async {
    if (!kIsWeb) return;

    try {
      final currentUser = auth.currentUser;
      final userId = currentUser?.uid ?? _getOrCreateAnonymousSessionId();
      final model = ConsentPreferenceModel.fromDomain(preference);

      await firestore.collection('consentLogs').doc(userId).set(
        {
          ...model.toFirestoreMap(),
          'userId': userId,
          'userAgent': web.window.navigator.userAgent,
          'isAnonymous': currentUser == null,
        },
        SetOptions(merge: true),
      );
    } on FirebaseException {
      // Don't throw - logging is optional
    } catch (e) {
      // Don't throw - logging is optional
    }
  }

  /// Gets or creates persistent anonymous session ID
  String _getOrCreateAnonymousSessionId() {
    var sessionId = web.window.localStorage.getItem(_localStorageSessionIdKey);
    if (sessionId == null) {
      sessionId = 'anon_${const Uuid().v4()}';
      web.window.localStorage.setItem(_localStorageSessionIdKey, sessionId);
    }
    return sessionId;
  }
}
