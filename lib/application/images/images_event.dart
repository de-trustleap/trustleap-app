// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'images_bloc.dart';

sealed class ImagesEvent extends Equatable {
  const ImagesEvent();

  @override
  List<Object> get props => [];
}

class UploadImageTriggeredEvent extends ImagesEvent {
  final XFile? rawImage;
  final String userID;

  const UploadImageTriggeredEvent({
    required this.rawImage,
    required this.userID,
  });
}

class UploadImageFromDropZoneTriggeredEvent extends ImagesEvent {
  final List<ProfileImageDroppedFile> files;
  final String userID;

  const UploadImageFromDropZoneTriggeredEvent({
    required this.files,
    required this.userID,
  });
}

class UploadImageForWebTriggeredEvent extends ImagesEvent {
  final XFile image;
  final String userID;

  const UploadImageForWebTriggeredEvent({
    required this.image,
    required this.userID,
  });
}

class UploadImageForAppTriggeredEvent extends ImagesEvent {
  final XFile image;
  final String userID;

  const UploadImageForAppTriggeredEvent({
    required this.image,
    required this.userID,
  });
}
