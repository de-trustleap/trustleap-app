part of 'image_cubit.dart';

sealed class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

final class ImageInitial extends ImageState {}

final class ImageUploadSuccessState extends ImageState {
  final String imageURL;

  const ImageUploadSuccessState({required this.imageURL});
}

final class ImageUploadLoadingState extends ImageState {}

final class ImageUploadFailureState extends ImageState {
  final StorageFailure failure;

  const ImageUploadFailureState({required this.failure});
}

final class ImageExceedsFileSizeLimitFailureState extends ImageState {}

final class ImageIsNotValidFailureState extends ImageState {}
