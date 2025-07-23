import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/domain/repositories/feedback_repository.dart';

part 'admin_feedback_state.dart';

class AdminFeedbackCubit extends Cubit<AdminFeedbackState> {
  final FeedbackRepository feedbackRepo;
  AdminFeedbackCubit(this.feedbackRepo) : super(AdminFeedbackInitial());

  void getFeedbackItems() async {
    emit(AdminFeedbackGetFeedbackLoadingState());
    final failureOrSuccess = await feedbackRepo.getFeedbackItems();
    failureOrSuccess.fold(
        (failure) =>
            emit(AdminFeedbackGetFeedbackFailureState(failure: failure)),
        (feedbacks) =>
            emit(AdminFeedbackGetFeedbackSuccessState(feedbacks: feedbacks)));
  }
}

// TODO: FEEDBACK IN FEEDBACKITEM UMBENENNEN
// TODO: TESTS ANPASSEN
// TODO: VIEW IMPLEMENTIEREN
