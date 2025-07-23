import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';

abstract class FeedbackRepository {
  Future<Either<DatabaseFailure, Unit>> sendFeedback(
      FeedbackItem feedback, List<Uint8List> images);
  Future<Either<DatabaseFailure, List<FeedbackItem>>> getFeedbackItems();
}
