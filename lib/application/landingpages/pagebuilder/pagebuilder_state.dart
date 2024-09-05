part of 'pagebuilder_cubit.dart';

sealed class PagebuilderState extends Equatable {
  const PagebuilderState();

  @override
  List<Object> get props => [];
}

final class PagebuilderInitial extends PagebuilderState {}

final class GetLandingPageLoadingState extends PagebuilderState {}

final class GetLandingPageFailureState extends PagebuilderState {
  final DatabaseFailure failure;

  const GetLandingPageFailureState({
    required this.failure
  });
}

final class GetLandingPageAndUserSuccessState extends PagebuilderState {
  final PagebuilderContent content;

  const GetLandingPageAndUserSuccessState({
    required this.content
  });
}