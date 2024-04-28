// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_image_bloc.dart';

sealed class ProfileImageEvent extends Equatable {
  const ProfileImageEvent();

  @override
  List<Object> get props => [];
}

class UploadImageTriggeredEvent extends ProfileImageEvent {
  final XFile? rawImage;
  final String id;

  const UploadImageTriggeredEvent(
      {required this.rawImage, required this.id});
}

class UploadImageFromDropZoneTriggeredEvent extends ProfileImageEvent {
  final List<ImageDroppedFile> files;
  final String id;

  const UploadImageFromDropZoneTriggeredEvent(
      {required this.files, required this.id});
}

class UploadImageForWebTriggeredEvent extends ProfileImageEvent {
  final XFile image;
  final String id;

  const UploadImageForWebTriggeredEvent(
      {required this.image, required this.id});
}

class UploadImageForAppTriggeredEvent extends ProfileImageEvent {
  final XFile image;
  final String id;

  const UploadImageForAppTriggeredEvent(
      {required this.image, required this.id});
}
