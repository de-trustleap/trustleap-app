part of 'landing_page_image_bloc.dart';

sealed class LandingPageImageEvent extends Equatable {
  const LandingPageImageEvent();

  @override
  List<Object> get props => [];
}

class UploadLandingPageImageTriggeredEvent extends LandingPageImageEvent {
  final Uint8List? rawImage;
  final String id;

  const UploadLandingPageImageTriggeredEvent(
      {required this.rawImage, required this.id});
}

class UploadLandingPageImageFromDropZoneTriggeredEvent
    extends LandingPageImageEvent {
  final List<ImageDroppedFile> files;
  final String id;

  const UploadLandingPageImageFromDropZoneTriggeredEvent(
      {required this.files, required this.id});
}

class UploadLandingPageImageForWebTriggeredEvent extends LandingPageImageEvent {
  final Uint8List image;
  final String id;

  const UploadLandingPageImageForWebTriggeredEvent(
      {required this.image, required this.id});
}

class UploadLandingPageImageForAppTriggeredEvent extends LandingPageImageEvent {
  final Uint8List image;
  final String id;

  const UploadLandingPageImageForAppTriggeredEvent(
      {required this.image, required this.id});
}
