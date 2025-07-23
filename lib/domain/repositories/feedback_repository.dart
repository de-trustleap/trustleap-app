import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/feedback.dart' as entities;

abstract class FeedbackRepository {
  Future<Either<DatabaseFailure, Unit>> sendFeedback(
      entities.Feedback feedback, List<Uint8List> images);
  Future<Either<DatabaseFailure, List<entities.Feedback>>> getFeedbackItems();
}
