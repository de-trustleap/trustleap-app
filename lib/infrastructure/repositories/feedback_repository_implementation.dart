// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/core/helpers/image_compressor.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/domain/repositories/feedback_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/feedback_item_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:web/web.dart';

class FeedbackRepositoryImplementation implements FeedbackRepository {
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;
  final FirebaseFirestore firestore;

  FeedbackRepositoryImplementation({
    required this.firebaseFunctions,
    required this.appCheck,
    required this.firestore,
  });

  @override
  Future<Either<DatabaseFailure, Unit>> sendFeedback(
      FeedbackItem feedback, List<Uint8List> images) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("sendFeedback");
    final feedbackModel = FeedbackItemModel.fromDomain(feedback);

    final userAgent = window.navigator.userAgent.toLowerCase();
    final compressedImages = await ImageCompressor.compressImages(images);
    final encodedImages =
        compressedImages.map((imageData) => base64Encode(imageData)).toList();

    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "id": feedbackModel.id,
        "title": feedbackModel.title,
        "description": feedbackModel.description,
        "images": encodedImages,
        "userAgent": userAgent
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
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
      return right(feedbackItems);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
