import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/feedback.dart';

abstract class FeedbackRepository {
  Future<Either<DatabaseFailure, Unit>> sendFeedback(
      Feedback feedback, List<Uint8List> images);
}
