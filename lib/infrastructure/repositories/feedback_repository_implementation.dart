// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/core/helpers/image_compressor.dart';
import 'package:finanzbegleiter/domain/entities/feedback.dart';
import 'package:finanzbegleiter/domain/repositories/feedback_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/feedback_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:web/web.dart';

class FeedbackRepositoryImplementation implements FeedbackRepository {
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  FeedbackRepositoryImplementation({
    required this.firebaseFunctions,
    required this.appCheck,
  });

  @override
  Future<Either<DatabaseFailure, Unit>> sendFeedback(
      Feedback feedback, List<Uint8List> images) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("sendFeedback");
    final feedbackModel = FeedbackModel.fromDomain(feedback);

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
}

// TODO: CUBIT EINBINDEN (FERTIG)
// TODO: NEUE TESTS FÜR CUBIT, REPO UND MODELS (FERTIG)
// TODO: LOCALIZATION (FERTIG)
// TODO: USER AGENT MITSCHICKEN
// TODO: TESTS AKTUALISIEREN
// TODO: BACKEND FUNKTION IMPLEMENTIEREN
// TODO: TESTEN!
