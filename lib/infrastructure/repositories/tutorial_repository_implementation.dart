// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/tutorial_repository.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TutorialRepositoryImplementation implements TutorialRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  TutorialRepositoryImplementation(
      {required this.firestore, required this.firebaseAuth});

  @override
  Future<Either<DatabaseFailure, int>> getCurrentStep(CustomUser user) async {
    try {
      final isVerified = await _isEmailVerified();
      final hasAllContactData = _hasAllContactData(user);
      final hasPendingCompanyRequest = _hasPendingCompanyRequest(user);
      final hasCompany = _hasRegisteredCompany(user);
      final hasDefaultLandingPage = _hasDefaultLandingPage(user);
      final hasLandingPage = _hasLandingPage(user);
      final hasUnregisteredPromoter = _hasUnregisteredPromoter(user);
      final hasRegisteredPromoter = _hasRegisteredPromoter(user);
      final hasRecommendation = _hasRecommendation(user);

      // Skip email verification for staging
      if (!Environment().isStaging() && !isVerified) {
        return right(0);
      }

      if (!hasAllContactData) {
        return right(1);
      }

      if (!hasPendingCompanyRequest &&
          !hasCompany &&
          user.tutorialStep != null &&
          user.tutorialStep! < 2) {
        return right(2);
      }

      if (hasPendingCompanyRequest && !hasCompany) {
        return right(3);
      }

      if (hasCompany && !hasDefaultLandingPage) {
        return right(4);
      }

      if (hasDefaultLandingPage && !hasLandingPage) {
        return right(5);
      }

      if (hasLandingPage &&
          !hasUnregisteredPromoter &&
          !hasRegisteredPromoter) {
        return right(6);
      }

      if (hasUnregisteredPromoter && !hasRegisteredPromoter) {
        return right(7);
      }

      if (hasRegisteredPromoter && !hasRecommendation) {
        return right(8);
      }

      if (hasRecommendation &&
          user.tutorialStep != null &&
          user.tutorialStep! < 10) {
        return right(9);
      }

      return right(10);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  Future<bool> _isEmailVerified() async {
    await firebaseAuth.currentUser?.reload();
    final user = firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }

  bool _hasAllContactData(CustomUser user) {
    if (user.gender != null &&
        user.firstName?.isNotEmpty == true &&
        user.lastName?.isNotEmpty == true &&
        user.tutorialStep != null &&
        user.tutorialStep! > 1) {
      return true;
    } else {
      return false;
    }
  }

  bool _hasPendingCompanyRequest(CustomUser user) {
    return user.pendingCompanyRequestID?.isNotEmpty == true;
  }

  bool _hasRegisteredCompany(CustomUser user) {
    return user.companyID?.isNotEmpty == true;
  }

  bool _hasDefaultLandingPage(CustomUser user) {
    return user.defaultLandingPageID?.isNotEmpty == true;
  }

  bool _hasLandingPage(CustomUser user) {
    return user.landingPageIDs?.isNotEmpty == true;
  }

  bool _hasUnregisteredPromoter(CustomUser user) {
    return user.unregisteredPromoterIDs?.isNotEmpty == true;
  }

  bool _hasRegisteredPromoter(CustomUser user) {
    return user.registeredPromoterIDs?.isNotEmpty == true;
  }

  bool _hasRecommendation(CustomUser user) {
    return user.recommendationIDs?.isNotEmpty == true;
  }

  @override
  Future<void> setStep(CustomUser user, int? step) async {
    final userModel = UserModel.fromDomain(user);
    final doc = firestore.collection("users").doc(userModel.id);
    await doc.update({"tutorialStep": step});
  }
}
