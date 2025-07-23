part of 'admin_feedback_cubit.dart';

sealed class AdminFeedbackState {}

final class AdminFeedbackInitial extends AdminFeedbackState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminFeedbackGetFeedbackLoadingState extends AdminFeedbackState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminFeedbackGetFeedbackFailureState extends AdminFeedbackState
    with EquatableMixin {
  final DatabaseFailure failure;
  AdminFeedbackGetFeedbackFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class AdminFeedbackGetFeedbackSuccessState extends AdminFeedbackState
    with EquatableMixin {
  final List<entities.Feedback> feedbacks;
  AdminFeedbackGetFeedbackSuccessState({required this.feedbacks});
  @override
  List<Object?> get props => [feedbacks];
}
