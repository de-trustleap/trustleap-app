part of 'company_image_bloc.dart';

sealed class CompanyImageEvent extends Equatable {
  const CompanyImageEvent();

  @override
  List<Object> get props => [];
}

class UploadCompanyImageTriggeredEvent extends CompanyImageEvent {
  final XFile? rawImage;
  final String id;

  const UploadCompanyImageTriggeredEvent(
      {required this.rawImage, required this.id});
}

class UploadCompanyImageFromDropZoneTriggeredEvent extends CompanyImageEvent {
  final List<ImageDroppedFile> files;
  final String id;

  const UploadCompanyImageFromDropZoneTriggeredEvent(
      {required this.files, required this.id});
}

class UploadCompanyImageForWebTriggeredEvent extends CompanyImageEvent {
  final XFile image;
  final String id;

  const UploadCompanyImageForWebTriggeredEvent(
      {required this.image, required this.id});
}

class UploadCompanyImageForAppTriggeredEvent extends CompanyImageEvent {
  final XFile image;
  final String id;

  const UploadCompanyImageForAppTriggeredEvent(
      {required this.image, required this.id});
}
