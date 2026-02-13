// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/features/images/domain/image_repository.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_dropped_file.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_image_event.dart';
part 'profile_image_state.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  final ImageRepository imageRepo;
  final fileSizeLimit = 5000000;

  ProfileImageBloc(
    this.imageRepo,
  ) : super(ImagesInitial()) {
    on<UploadImageTriggeredEvent>((event, emit) async {
      emit(ProfileImageUploadLoadingState());
      if (event.rawImage != null) {
        if (kIsWeb) {
          add(UploadImageForWebTriggeredEvent(
              image: event.rawImage!, id: event.id));
        } else {
          add(UploadImageForAppTriggeredEvent(
              image: event.rawImage!, id: event.id));
        }
      } else {
        emit(ImageUploadCancelledState());
      }
    }, transformer: restartable());

    on<UploadImageFromDropZoneTriggeredEvent>((event, emit) {
      emit(ProfileImageUploadLoadingState());
      if (event.files.length > 1) {
        emit(ProfileImageOnlyOneAllowedFailureState());
        return;
      } else if (event.files.isEmpty) {
        emit(ProfileImageIsNotValidFailureState());
      } else {
        final file = event.files.first;
        if (file.mime.contains("image")) {
          final xFileImage = XFile.fromData(file.data);
          add(UploadImageTriggeredEvent(rawImage: xFileImage, id: event.id));
        } else {
          emit(ProfileImageIsNotValidFailureState());
        }
      }
    });

    on<UploadImageForWebTriggeredEvent>((event, emit) async {
      final selectedImage = await event.image.readAsBytes();
      final imageFileSize = selectedImage.length;
      final isImageValid = await _isImageValid(selectedImage);
      if (!isImageValid) {
        emit(ProfileImageIsNotValidFailureState());
        return;
      }
      if (imageFileSize > fileSizeLimit) {
        emit(ProfileImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess = await imageRepo.uploadImageForWeb(
          selectedImage, event.id, ImageUploader.user);
      failureOrSuccess.fold(
          (failure) => emit(ProfileImageUploadFailureState(failure: failure)),
          (imageURL) =>
              emit(ProfileImageUploadSuccessState(imageURL: imageURL)));
    });

    on<UploadImageForAppTriggeredEvent>((event, emit) async {
      final selectedImage = File(event.image.path);
      final imageFileSize = await selectedImage.length();
      if (imageFileSize > fileSizeLimit) {
        emit(ProfileImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess = await imageRepo.uploadImageForApp(
          selectedImage, event.id, ImageUploader.user);
      failureOrSuccess.fold(
          (failure) => emit(ProfileImageUploadFailureState(failure: failure)),
          (imageURL) =>
              emit(ProfileImageUploadSuccessState(imageURL: imageURL)));
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
