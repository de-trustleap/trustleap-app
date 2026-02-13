import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_item.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_repository.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository feedbackRepo;
  FeedbackCubit(this.feedbackRepo) : super(FeedbackInitial());

  void sendFeedback(FeedbackItem feedback, List<Uint8List> images) async {
    emit(SentFeedbackLoadingState());
    final failureOrSuccess = await feedbackRepo.sendFeedback(feedback, images);
    failureOrSuccess.fold(
        (failure) => emit(SentFeedbackFailureState(failure: failure)),
        (unit) => emit(SentFeedbackSuccessState()));
  }

}
