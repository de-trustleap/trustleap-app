// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/image_upload/image_dropped_file.dart';

part 'company_image_event.dart';
part 'company_image_state.dart';

class CompanyImageBloc extends Bloc<CompanyImageEvent, CompanyImageState> {
  final ImageRepository imageRepo;
  final fileSizeLimit = 5000000;

  CompanyImageBloc(
    this.imageRepo,
  ) : super(CompanyImageInitial()) {
    on<UploadCompanyImageTriggeredEvent>((event, emit) async {
      emit(CompanyImageUploadLoadingState());
      if (event.rawImage != null) {
        if (kIsWeb) {
          add(UploadCompanyImageForWebTriggeredEvent(
              image: event.rawImage!, id: event.id));
        } else {
          add(UploadCompanyImageForAppTriggeredEvent(
              image: event.rawImage!, id: event.id));
        }
      } else {
        emit(CompanyUploadCancelledState());
      }
    }, transformer: restartable());

    on<UploadCompanyImageFromDropZoneTriggeredEvent>((event, emit) {
      emit(CompanyImageUploadLoadingState());
      if (event.files.length > 1) {
        emit(CompanyImageOnlyOneAllowedFailureState());
        return;
      } else if (event.files.isEmpty) {
        emit(CompanyImageIsNotValidFailureState());
      } else {
        final file = event.files.first;
        if (file.mime.contains("image")) {
          final xFileImage = XFile.fromData(file.data);
          add(UploadCompanyImageTriggeredEvent(
              rawImage: xFileImage, id: event.id));
        } else {
          emit(CompanyImageIsNotValidFailureState());
        }
      }
    });

    on<UploadCompanyImageForWebTriggeredEvent>((event, emit) async {
      final selectedImage = await event.image.readAsBytes();
      final imageFileSize = selectedImage.length;
      final isImageValid = await _isImageValid(selectedImage);
      if (!isImageValid) {
        emit(CompanyImageIsNotValidFailureState());
        return;
      }
      if (imageFileSize > fileSizeLimit) {
        emit(CompanyImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess = await imageRepo.uploadImageForWeb(
          selectedImage, event.id, ImageUploader.company);
      failureOrSuccess.fold(
          (failure) => emit(CompanyImageUploadFailureState(failure: failure)),
          (imageURL) =>
              emit(CompanyImageUploadSuccessState(imageURL: imageURL)));
    });

    on<UploadCompanyImageForAppTriggeredEvent>((event, emit) async {
      final selectedImage = File(event.image.path);
      final imageFileSize = await selectedImage.length();
      if (imageFileSize > fileSizeLimit) {
        emit(CompanyImageExceedsFileSizeLimitFailureState());
        return;
      }
      final failureOrSuccess = await imageRepo.uploadImageForApp(
          selectedImage, event.id, ImageUploader.company);
      failureOrSuccess.fold(
          (failure) => emit(CompanyImageUploadFailureState(failure: failure)),
          (imageURL) =>
              emit(CompanyImageUploadSuccessState(imageURL: imageURL)));
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
