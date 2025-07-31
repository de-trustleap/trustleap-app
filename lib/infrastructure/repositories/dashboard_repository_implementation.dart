// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_ranked_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/archived_recommendation_item_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

class DashboardRepositoryImplementation implements DashboardRepository {
  final FirebaseFirestore firestore;
  DashboardRepositoryImplementation({
    required this.firestore,
  });

  @override
  Future<Either<DatabaseFailure, List<DashboardRankedPromoter>>>
      getTop3Promoters(List<String> registeredPromoterIDs) async {
    if (registeredPromoterIDs.isEmpty) {
      return right([]);
    }

    final userCollection = firestore.collection("users");
    final archivedRecoCollection =
        firestore.collection("archivedRecommendations");

    try {
      // 1. Get all promoters
      final promotersResult =
          await _getPromotersFromIDs(registeredPromoterIDs, userCollection);

      if (promotersResult.isLeft()) {
        return promotersResult.fold(
            (failure) => left(failure), (_) => right([]));
      }

      final promoters = promotersResult.getOrElse(() => []);

      if (promoters.isEmpty) {
        return right([]);
      }

      // 2. Count completed recommendations for each promoter
      final Map<String, int> promoterCompletedCounts = {};
      final Map<String, String> promoterIDToName = {};

      for (final promoter in promoters) {
        if (promoter.recommendationIDs == null ||
            promoter.recommendationIDs!.isEmpty) {
          promoterCompletedCounts[promoter.id.value] = 0;
        } else {
          final completedCountResult = await _countCompletedRecommendations(
              promoter.recommendationIDs!, archivedRecoCollection);

          if (completedCountResult.isLeft()) {
            return completedCountResult.fold(
                (failure) => left(failure), (_) => left(BackendFailure()));
          }

          promoterCompletedCounts[promoter.id.value] =
              completedCountResult.getOrElse(() => 0);
        }

        // Store promoter name for later use
        final fullName =
            "${promoter.firstName ?? ''} ${promoter.lastName ?? ''}".trim();
        promoterIDToName[promoter.id.value] =
            fullName.isEmpty ? "Unknown Promoter" : fullName;
      }

      // 3. Sort by completed count and take top 3
      final sortedPromoters = promoterCompletedCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final top3 = sortedPromoters.take(3).toList();

      // 4. Convert to DashboardRankedPromoter
      final result = top3.asMap().entries.map((entry) {
        final rank = entry.key + 1; // 1-based ranking
        final promoterEntry = entry.value;
        final promoterID = promoterEntry.key;
        final completedCount = promoterEntry.value;
        final promoterName = promoterIDToName[promoterID] ?? "Unknown Promoter";

        return DashboardRankedPromoter(
          promoterName: promoterName,
          rank: rank,
          completedRecommendationsCount: completedCount,
        );
      }).toList();

      return right(result);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  /// Helper method to get promoters from their IDs
  Future<Either<DatabaseFailure, List<CustomUser>>> _getPromotersFromIDs(
      List<String> promoterIDs,
      CollectionReference<Map<String, dynamic>> userCollection) async {
    // Split into chunks of 10 for Firestore whereIn limitation
    final chunks = promoterIDs.slices(10);
    final List<CustomUser> promoters = [];

    try {
      for (final chunk in chunks) {
        final querySnapshot = await userCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final doc in querySnapshot.docs) {
          if (doc.exists) {
            final user = UserModel.fromFirestore(doc.data(), doc.id).toDomain();
            promoters.add(user);
          }
        }
      }

      return right(promoters);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  /// Helper method to count completed recommendations for a promoter
  Future<Either<DatabaseFailure, int>> _countCompletedRecommendations(
      List<String> recommendationIDs,
      CollectionReference<Map<String, dynamic>> archivedRecoCollection) async {
    if (recommendationIDs.isEmpty) {
      return right(0);
    }

    // Split into chunks of 10 for Firestore whereIn limitation
    final chunks = recommendationIDs.slices(10);
    int completedCount = 0;

    try {
      for (final chunk in chunks) {
        final querySnapshot = await archivedRecoCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final doc in querySnapshot.docs) {
          if (doc.exists) {
            final archivedReco = ArchivedRecommendationItemModel.fromFirestore(
                doc.data(), doc.id);

            if (archivedReco.success != null) {
              completedCount++;
            }
          }
        }
      }

      return right(completedCount);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
