part of 'pagebuilder_cubit.dart';

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

  GetLandingPageAndUserSuccessState(
      {required this.content,
      required this.saveLoading,
      required this.saveFailure});

  @override
  List<Object?> get props => [content, saveLoading, saveFailure];
}

final class SavePageSuccessState extends PagebuilderState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PageBuilderUnexpectedFailureState extends PagebuilderState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
