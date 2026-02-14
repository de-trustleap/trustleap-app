part of 'landing_page_image_bloc.dart';

sealed class LandingPageImageState extends Equatable {
  const LandingPageImageState();

  @override
  List<Object> get props => [];
}

final class LandingPageImageInitial extends LandingPageImageState {}

final class LandingPageImageUploadSuccessState extends LandingPageImageState {
  final String imageURL;

  const LandingPageImageUploadSuccessState({required this.imageURL});
}

final class LandingPageImageUploadLoadingState extends LandingPageImageState {}

final class LandingPageUploadCancelledState extends LandingPageImageState {}

final class LandingPageImageUploadFailureState extends LandingPageImageState {
  final StorageFailure failure;

  const LandingPageImageUploadFailureState({required this.failure});
}

final class LandingPageImageExceedsFileSizeLimitFailureState
    extends LandingPageImageState {}

final class LandingPageImageIsNotValidFailureState
    extends LandingPageImageState {}

final class LandingPageImageOnlyOneAllowedFailureState
    extends LandingPageImageState {}

final class LandingPageImageUploadNotFoundFailureState
    extends LandingPageImageState {}
