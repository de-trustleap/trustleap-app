part of 'pagebuilder_bloc.dart';

sealed class PagebuilderState {}

final class PagebuilderInitial extends PagebuilderState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class GetLandingPageLoadingState extends PagebuilderState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class GetLandingPageFailureState extends PagebuilderState
    with EquatableMixin {
  final DatabaseFailure failure;

  GetLandingPageFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class GetLandingPageAndUserSuccessState extends PagebuilderState
    with EquatableMixin {
  final PagebuilderContent content;
  final bool saveLoading;
  final DatabaseFailure? saveFailure;
  final bool? saveSuccessful;
  final bool? isUpdated;
  final int _timestamp;

  GetLandingPageAndUserSuccessState(
      {required this.content,
      required this.saveLoading,
      required this.saveFailure,
      required this.saveSuccessful,
      required this.isUpdated})
      : _timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props =>
      [content, saveLoading, saveFailure, saveSuccessful, isUpdated, _timestamp];
}

final class PageBuilderUnexpectedFailureState extends PagebuilderState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
