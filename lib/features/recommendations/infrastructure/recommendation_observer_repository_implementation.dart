import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/profile/infrastructure/user_model.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_observer_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/recommendation_item_model.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/user_recommendation_model.dart';
import 'package:rxdart/rxdart.dart';

class RecommendationObserverRepositoryImplementation
    implements RecommendationObserverRepository {
  final FirebaseFirestore firestore;

  RecommendationObserverRepositoryImplementation({required this.firestore});

  static const int _whereInChunkSize = 30;

  @override
  Stream<Either<DatabaseFailure, List<UserRecommendation>>>
      observeRecommendations(List<String> userRecoIDs) {
    return _buildObserveStream(userRecoIDs)
        .map<Either<DatabaseFailure, List<UserRecommendation>>>(
            (list) => right(list))
        .onErrorReturnWith((e, _) {
      if (e is FirebaseException) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      }
      return left(BackendFailure());
    });
  }

  @override
  Future<Either<DatabaseFailure, List<String>>> aggregateCompanyUserRecoIDs(
      CustomUser companyUser) async {
    final ownIDs = companyUser.recommendationIDs ?? <String>[];
    final promoterIDs = companyUser.registeredPromoterIDs ?? <String>[];

    if (promoterIDs.isEmpty) {
      return right(ownIDs.toList());
    }

    try {
      final all = <String>{...ownIDs};
      final userCollection = firestore.collection('users');
      final chunks = promoterIDs.slices(_whereInChunkSize).toList();

      for (final chunk in chunks) {
        final snap = await userCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (final doc in snap.docs) {
          final promoter =
              UserModel.fromFirestore(doc.data(), doc.id).toDomain();
          if (promoter.deletesAt == null && promoter.recommendationIDs != null) {
            all.addAll(promoter.recommendationIDs!);
          }
        }
      }
      return right(all.toList());
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  Stream<List<UserRecommendation>> _buildObserveStream(
      List<String> userRecoIDs) {
    if (userRecoIDs.isEmpty) {
      return Stream.value(<UserRecommendation>[]);
    }

    final usersRecosCollection = firestore.collection("usersRecommendations");
    final recoCollection = firestore.collection("recommendations");

    final userRecoChunks = userRecoIDs.slices(_whereInChunkSize).toList();

    final Stream<List<UserRecommendation>> userRecosStream;
    if (userRecoChunks.length == 1) {
      userRecosStream = usersRecosCollection
          .where(FieldPath.documentId, whereIn: userRecoChunks.first)
          .snapshots()
          .map((snap) => snap.docs
              .map((d) => UserRecommendationModel.fromFirestore(d.data(), d.id)
                  .toDomain())
              .toList());
    } else {
      final chunkStreams = userRecoChunks
          .map((chunk) => usersRecosCollection
              .where(FieldPath.documentId, whereIn: chunk)
              .snapshots()
              .map((snap) => snap.docs))
          .toList();
      userRecosStream =
          Rx.combineLatestList(chunkStreams).map((listOfDocLists) {
        final all = <UserRecommendation>[];
        for (final docList in listOfDocLists) {
          for (final doc in docList) {
            all.add(UserRecommendationModel.fromFirestore(doc.data(), doc.id)
                .toDomain());
          }
        }
        return all;
      });
    }

    return userRecosStream.switchMap((urs) {
      final recoIDs = urs
          .where((r) => r.recoID != null)
          .map((r) => r.recoID!)
          .toSet();

      if (recoIDs.isEmpty) {
        return Stream.value(<UserRecommendation>[]);
      }

      return _buildRecoMapStream(recoCollection, recoIDs.toList()).map((rmap) {
        final byRecoID = <String, UserRecommendation>{};
        for (final u in urs) {
          if (u.recoID != null) byRecoID[u.recoID!] = u;
        }
        final entries = rmap.entries.toList()
          ..sort((a, b) => b.value.createdAt.compareTo(a.value.createdAt));
        final merged = <UserRecommendation>[];
        for (final e in entries) {
          final u = byRecoID[e.key];
          if (u != null) merged.add(u.copyWith(recommendation: e.value));
        }
        return merged;
      });
    }).debounceTime(const Duration(milliseconds: 50));
  }

  Stream<Map<String, RecommendationItem>> _buildRecoMapStream(
      CollectionReference<Map<String, dynamic>> recoCollection,
      List<String> recoIDs) {
    final recoChunks = recoIDs.slices(_whereInChunkSize).toList();

    if (recoChunks.length == 1) {
      return recoCollection
          .where(FieldPath.documentId, whereIn: recoChunks.first)
          .snapshots()
          .map((snap) {
        final m = <String, RecommendationItem>{};
        for (final doc in snap.docs) {
          m[doc.id] =
              RecommendationItemModel.fromFirestore(doc.data(), doc.id)
                  .toDomain();
        }
        return m;
      });
    }

    final recoChunkStreams = recoChunks
        .map((chunk) => recoCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .snapshots()
            .map((snap) => snap.docs))
        .toList();
    return Rx.combineLatestList(recoChunkStreams).map((listOfDocLists) {
      final m = <String, RecommendationItem>{};
      for (final docList in listOfDocLists) {
        for (final doc in docList) {
          m[doc.id] =
              RecommendationItemModel.fromFirestore(doc.data(), doc.id)
                  .toDomain();
        }
      }
      return m;
    });
  }
}
