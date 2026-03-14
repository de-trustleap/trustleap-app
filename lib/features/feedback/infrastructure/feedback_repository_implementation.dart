// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/cloud_functions_service.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/core/helpers/image_compressor.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_item.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_repository.dart';
import 'package:finanzbegleiter/features/feedback/infrastructure/feedback_item_model.dart';
import 'package:finanzbegleiter/core/helpers/web_interop.dart';

class FeedbackRepositoryImplementation implements FeedbackRepository {
  final CloudFunctionsService cloudFunctions;
  final FirebaseFirestore firestore;

  FeedbackRepositoryImplementation({
    required this.cloudFunctions,
    required this.firestore,
  });

  @override
  Future<Either<DatabaseFailure, Unit>> sendFeedback(
      FeedbackItem feedback, List<Uint8List> images) async {
    final feedbackModel = FeedbackItemModel.fromDomain(feedback);
    final userAgent = WebInterop.userAgent.toLowerCase();
    final compressedImages = await ImageCompressor.compressImages(images);
    final encodedImages =
        compressedImages.map((imageData) => base64Encode(imageData)).toList();

    return cloudFunctions.call(
      'sendFeedback',
      {
        'id': feedbackModel.id,
        'title': feedbackModel.title,
        'description': feedbackModel.description,
        'email': feedbackModel.email,
        'type': feedbackModel.type,
        'images': encodedImages,
        'userAgent': userAgent,
      },
      (_) => unit,
    );
  }

  @override
  Future<Either<DatabaseFailure, List<FeedbackItem>>> getFeedbackItems() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection("feedback").get();
      List<FeedbackItem> feedbackItems = [];
      for (final doc in querySnapshot.docs) {
        final map = doc.data() as Map<String, dynamic>;
        feedbackItems
            .add(FeedbackItemModel.fromFirestore(map, doc.id).toDomain());
      }
      if (feedbackItems.isEmpty) {
        return left(NotFoundFailure());
      }

      feedbackItems.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return right(feedbackItems);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> deleteFeedback(String id) async {
    return cloudFunctions.call(
      'deleteFeedback',
      {'feedbackID': id},
      (_) => unit,
    );
  }
}
