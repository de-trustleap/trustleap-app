// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'landingpage_state.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  final LandingPageRepository landingPageRepo;
  final UserRepository userRepo;
  final fileSizeLimit = 5000000;

  LandingPageCubit(
    this.landingPageRepo,
    this.userRepo,
  ) : super(LandingPageInitial());

  void createLandingPage(LandingPage? landingpage, Uint8List imageData,
      bool imageHasChanged) async {
    if (landingpage == null) {
      emit(LandingPageShowValidationState());
    } else if (imageData == [0]) {
      emit(LandingPageNoImageFailureState());
    } else if (imageData.lengthInBytes > fileSizeLimit) {
      emit(LandingPageImageExceedsFileSizeLimitFailureState());
    } else {
      emit(CreateLandingPageLoadingState());
      final failureOrSuccess = await landingPageRepo.createLandingPage(
          landingpage, imageData, imageHasChanged);
      failureOrSuccess.fold(
          (failure) => emit(CreateLandingPageFailureState(failure: failure)),
          (_) => emit(CreatedLandingPageSuccessState()));
    }
  }

  void editLandingPage(LandingPage? landingPage, Uint8List? imageData,
      bool imageHasChanged) async {
    if (landingPage == null) {
      emit(LandingPageShowValidationState());
    } else if (imageData != null && imageData.lengthInBytes > fileSizeLimit) {
      emit(LandingPageImageExceedsFileSizeLimitFailureState());
    } else {
      emit(EditLandingPageLoadingState());
      final failureOrSuccess = await landingPageRepo.editLandingPage(
          landingPage, imageData, imageHasChanged);
      failureOrSuccess.fold(
          (failure) => emit(EditLandingPageFailureState(failure: failure)),
          (_) => emit(EditLandingPageSuccessState()));
    }
  }

  void deleteLandingPage(String id, String parentUserID) async {
    emit(DeleteLandingPageLoadingState());
    final failureOrSuccess =
        await landingPageRepo.deleteLandingPage(id, parentUserID);
    failureOrSuccess.fold(
        (failure) => emit(DeleteLandingPageFailureState(failure: failure)),
        (_) => emit(DeleteLandingPageSuccessState()));
  }

  void duplicateLandingPage(String id) async {
    emit(DuplicateLandingPageLoadingState());
    final failureOrSuccess = await landingPageRepo.duplicateLandingPage(id);
    failureOrSuccess.fold(
        (failure) => emit(DuplicateLandingPageFailureState(failure: failure)),
        (_) => emit(DuplicateLandingPageSuccessState()));
  }

  void troggleLandingPageActivity(String id, bool isActive) async {
    emit(TroggleLandingPageActivityLoadingState());
    final failureOrSuccess = await landingPageRepo.troggleLandingPageActivity(id, isActive);
    failureOrSuccess.fold(
        (failure) => emit(TroggleLandingPageActivityFailureState(failure: failure)),
        (_) => emit(TroggleLandingPageActivitySuccessState()));
  }

  void getUser() async {
    emit(GetUserLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold(
        (failure) => emit(GetUserFailureState(failure: failure)),
        (user) => emit(GetUserSuccessState(user: user)));
  }
}
