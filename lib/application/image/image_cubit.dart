// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  final ImageRepository imageRepo;
  final fileSizeLimit = 5000000;

  ImageCubit(
    this.imageRepo,
  ) : super(ImageInitial());

  void uploadImage(XFile? rawImage, String userID) async {
    emit(ImageUploadLoadingState());
    if (rawImage != null) {
      if (kIsWeb) {
        _uploadImageForWeb(rawImage, userID);
      } else {
        _uploadImageForApp(rawImage, userID);
      }
    } else {
      emit(ImageIsNotValidFailureState());
    }
  }

  void _uploadImageForWeb(XFile image, String userID) async {
    final selectedImage = await image.readAsBytes();
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
        await imageRepo.uploadImageForWeb(selectedImage, userID);
    failureOrSuccess.fold(
        (failure) => emit(ImageUploadFailureState(failure: failure)),
        (imageURL) => emit(ImageUploadSuccessState(imageURL: imageURL)));
  }

  void _uploadImageForApp(XFile image, String userID) async {
    final selectedImage = File(image.path);
    final imageFileSize = await selectedImage.length();
    if (imageFileSize > fileSizeLimit) {
      emit(ImageExceedsFileSizeLimitFailureState());
      return;
    }
    final failureOrSuccess =
        await imageRepo.uploadImageForApp(selectedImage, userID);
    failureOrSuccess.fold(
        (failure) => emit(ImageUploadFailureState(failure: failure)),
        (imageURL) => emit(ImageUploadSuccessState(imageURL: imageURL)));
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
