import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/feedback_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository feedbackRepo;
  final UserRepository userRepo;
  FeedbackCubit(this.feedbackRepo, this.userRepo) : super(FeedbackInitial());

  void sendFeedback(FeedbackItem feedback, List<Uint8List> images) async {
    emit(SentFeedbackLoadingState());
    final failureOrSuccess = await feedbackRepo.sendFeedback(feedback, images);
    failureOrSuccess.fold(
        (failure) => emit(SentFeedbackFailureState(failure: failure)),
        (unit) => emit(SentFeedbackSuccessState()));
  }

  void getUser() async {
    emit(FeedbackGetUserLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold(
        (failure) => emit(FeedbackGetUserFailureState(failure: failure)),
        (user) => emit(FeedbackGetUserSuccessState(user: user)));
  }
}

// TODO: GET USER CALL EINBINDEN UND EMAIL FELD VORAUSFÜLLEN, FALLS VORHANDEN.
// TODO: TESTS AKTUALISIEREN UND ERWEITERN (FERTIG)
// TODO: BACKEND ARBEITEN
// TODO: LOCALIZATION
