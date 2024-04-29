// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_helpers.dart';
import 'package:finanzbegleiter/infrastructure/models/landing_page_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

class LandingPageRepositoryImplementation implements LandingPageRepository {
  final FirebaseFirestore firestore;

  LandingPageRepositoryImplementation({
    required this.firestore,
  });

  @override
  Stream<Either<DatabaseFailure, CustomUser>> observeAllLandingPages() async* {
      final userDoc = await firestore.userDocument();
      var requestedUser = await userDoc.get();
      if (!requestedUser.exists) {
        yield left(NotFoundFailure());
      }
      yield* userDoc.snapshots().map((snapshot) {
        var document = snapshot.data() as Map<String, dynamic>;
        var model = UserModel.fromFirestore(document, snapshot.id).toDomain();
        return right<DatabaseFailure, CustomUser>(model);
      }).handleError((e) {
        if (e is FirebaseException) {
          return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
        } else {
          return left(BackendFailure());
        }
    });
  }

  @override
  Future<Either<DatabaseFailure, List<LandingPage>>> getAllLandingPages(List<String> ids) async {
    final landingPagesCollection = firestore.collection("landingPages");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<LandingPage> landingPages = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await landingPagesCollection
            .orderBy("name", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = LandingPageModel.fromFirestore(doc, snapshot.id).toDomain();
          landingPages.add(model);
        }
      }
      landingPages.sort((a, b) {
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!);
        } else {
          return a.id.value.compareTo(b.id.value);
        }
      });
      return right(landingPages);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

}
