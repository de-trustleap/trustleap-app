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

final class FeedbackGetUserLoadingState extends FeedbackState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class FeedbackGetUserFailureState extends FeedbackState
    with EquatableMixin {
  final DatabaseFailure failure;
  FeedbackGetUserFailureState({required this.failure});
  @override
  List<Object> get props => [failure];
}

final class FeedbackGetUserSuccessState extends FeedbackState
    with EquatableMixin {
  final CustomUser user;
  FeedbackGetUserSuccessState({required this.user});
  @override
  List<Object> get props => [user];
}
