part of 'profile_image_bloc.dart';

sealed class ProfileImageState extends Equatable {
  const ProfileImageState();

  @override
  List<Object> get props => [];
}

final class ImagesInitial extends ProfileImageState {}

final class ProfileImageUploadSuccessState extends ProfileImageState {
  final String imageURL;

  const ProfileImageUploadSuccessState({required this.imageURL});
}

final class ProfileImageUploadLoadingState extends ProfileImageState {}

final class ImageUploadCancelledState extends ProfileImageState {}

final class ProfileImageUploadFailureState extends ProfileImageState {
  final StorageFailure failure;

  const ProfileImageUploadFailureState({required this.failure});
}

final class ProfileImageExceedsFileSizeLimitFailureState
    extends ProfileImageState {}

final class ProfileImageIsNotValidFailureState extends ProfileImageState {}

final class ProfileImageOnlyOneAllowedFailureState extends ProfileImageState {}

final class ProfileImageUploadNotFoundFailureState extends ProfileImageState {}
