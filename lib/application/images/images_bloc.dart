// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/profile_image_dropped_file.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final ImageRepository imageRepo;
  final fileSizeLimit = 5000000;

  ImagesBloc(
    this.imageRepo,
  ) : super(ImagesInitial()) {
    on<UploadImageTriggeredEvent>((event, emit) async {
      emit(ImageUploadLoadingState());
      if (event.rawImage != null) {
        if (kIsWeb) {
          add(UploadImageForWebTriggeredEvent(
              image: event.rawImage!, userID: event.userID));
        } else {
          add(UploadImageForAppTriggeredEvent(
              image: event.rawImage!, userID: event.userID));
        }
      } else {
        emit(ImageUploadCancelledState());
      }
    }, transformer: restartable());

    on<UploadImageFromDropZoneTriggeredEvent>((event, emit) {
      emit(ImageUploadLoadingState());
      if (event.files.length > 1) {
        emit(ImageOnlyOneAllowedFailureState());
        return;
      } else if (event.files.isEmpty) {
        emit(ImageIsNotValidFailureState());
      } else {
        final file = event.files.first;
        if (file.mime.contains("image")) {
          final xFileImage = XFile.fromData(file.data);
          add(UploadImageTriggeredEvent(
              rawImage: xFileImage, userID: event.userID));
        } else {
          emit(ImageIsNotValidFailureState());
        }
      }
    });

    on<UploadImageForWebTriggeredEvent>((event, emit) async {
      final selectedImage = await event.image.readAsBytes();
      final imageFileSize = selectedImage.length;
      final isImageValid = await _isImageValid(selectedImage);
      if (!isImageValid) {
        emit(ImageIsNotValidFailureState());
        return;
      }
      if (imageFileSize > fileSizeLimit) {
        emit(ImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess =
          await imageRepo.uploadImageForWeb(selectedImage, event.userID);
      failureOrSuccess.fold(
          (failure) => emit(ImageUploadFailureState(failure: failure)),
          (imageURL) => emit(ImageUploadSuccessState(imageURL: imageURL)));
    });

    on<UploadImageForAppTriggeredEvent>((event, emit) async {
      final selectedImage = File(event.image.path);
      final imageFileSize = await selectedImage.length();
      if (imageFileSize > fileSizeLimit) {
        emit(ImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess =
          await imageRepo.uploadImageForApp(selectedImage, event.userID);
      failureOrSuccess.fold(
          (failure) => emit(ImageUploadFailureState(failure: failure)),
          (imageURL) => emit(ImageUploadSuccessState(imageURL: imageURL)));
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
