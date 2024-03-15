part of 'images_bloc.dart';

sealed class ImagesState extends Equatable {
  const ImagesState();

  @override
  List<Object> get props => [];
}

final class ImagesInitial extends ImagesState {}

final class ImageUploadSuccessState extends ImagesState {
  final String imageURL;

  const ImageUploadSuccessState({required this.imageURL});
}

final class ImageUploadLoadingState extends ImagesState {}

final class ImageUploadCancelledState extends ImagesState {}

final class ImageUploadFailureState extends ImagesState {
  final StorageFailure failure;

  const ImageUploadFailureState({required this.failure});
}

final class ImageExceedsFileSizeLimitFailureState extends ImagesState {}

final class ImageIsNotValidFailureState extends ImagesState {}

final class ImageOnlyOneAllowedFailureState extends ImagesState {}

final class ImageUploadNotFoundFailureState extends ImagesState {}
