import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/image_dropped_file.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'landing_page_image_event.dart';
part 'landing_page_image_state.dart';

class LandingPageImageBloc
    extends Bloc<LandingPageImageEvent, LandingPageImageState> {
  final ImageRepository imageRepo;
  final fileSizeLimit = 5000000;

  LandingPageImageBloc(this.imageRepo) : super(LandingPageImageInitial()) {
    on<UploadLandingPageImageTriggeredEvent>((event, emit) {
      emit(LandingPageImageUploadLoadingState());
      if (event.rawImage != null) {
        if (kIsWeb) {
          add(UploadLandingPageImageForWebTriggeredEvent(
              image: event.rawImage!, id: event.id));
        } else {
          add(UploadLandingPageImageForAppTriggeredEvent(
              image: event.rawImage!, id: event.id));
        }
      } else {
        emit(LandingPageUploadCancelledState());
      }
    }, transformer: restartable());

    on<UploadLandingPageImageFromDropZoneTriggeredEvent>((event, emit) {
      emit(LandingPageImageUploadLoadingState());
      if (event.files.length > 1) {
        emit(LandingPageImageOnlyOneAllowedFailureState());
        return;
      } else if (event.files.isEmpty) {
        emit(LandingPageImageIsNotValidFailureState());
      } else {
        final file = event.files.first;
        if (file.mime.contains("image")) {
          final xFileImage = XFile.fromData(file.data);
          add(UploadLandingPageImageTriggeredEvent(
              rawImage: xFileImage, id: event.id));
        } else {
          emit(LandingPageImageIsNotValidFailureState());
        }
      }
    });

    on<UploadLandingPageImageForWebTriggeredEvent>((event, emit) async {
      final selectedImage = await event.image.readAsBytes();
      final imageFileSize = selectedImage.length;
      final isImageValid = await _isImageValid(selectedImage);
      if (!isImageValid) {
        emit(LandingPageImageIsNotValidFailureState());
        return;
      }
      if (imageFileSize > fileSizeLimit) {
        emit(LandingPageImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess = await imageRepo.uploadImageForWeb(
          selectedImage, event.id, ImageUploader.landingPage);
      failureOrSuccess.fold(
          (failure) =>
              emit(LandingPageImageUploadFailureState(failure: failure)),
          (imageURL) =>
              emit(LandingPageImageUploadSuccessState(imageURL: imageURL)));
    });

    on<UploadLandingPageImageForAppTriggeredEvent>((event, emit) async {
      final selectedImage = File(event.image.path);
      final imageFileSize = await selectedImage.length();
      if (imageFileSize > fileSizeLimit) {
        emit(LandingPageImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess = await imageRepo.uploadImageForApp(
          selectedImage, event.id, ImageUploader.landingPage);
      failureOrSuccess.fold(
          (failure) =>
              emit(LandingPageImageUploadFailureState(failure: failure)),
          (imageURL) =>
              emit(LandingPageImageUploadSuccessState(imageURL: imageURL)));
    });
  }

  Future<bool> _isImageValid(List<int> rawList) async {
    final uInt8List =
        rawList is Uint8List ? rawList : Uint8List.fromList(rawList);
    try {
      final codec = await instantiateImageCodec(uInt8List, targetWidth: 32);
      final frameInfo = await codec.getNextFrame();
      return frameInfo.image.width > 0;
    } catch (e) {
      return false;
    }
  }
}
