part of 'feedback_cubit.dart';

sealed class FeedbackState {}

final class FeedbackInitial extends FeedbackState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class SentFeedbackLoadingState extends FeedbackState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class SentFeedbackFailureState extends FeedbackState with EquatableMixin {
  final DatabaseFailure failure;
  SentFeedbackFailureState({required this.failure});
  @override
  List<Object> get props => [failure];
}

final class SentFeedbackSuccessState extends FeedbackState with EquatableMixin {
  @override
  List<Object> get props => [];
}
