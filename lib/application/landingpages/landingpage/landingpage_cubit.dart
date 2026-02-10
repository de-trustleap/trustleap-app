// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/landing_page_template.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_ai_generation.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';

part 'landingpage_state.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  final LandingPageRepository landingPageRepo;
  final fileSizeLimit = 5000000;

  LandingPageCubit(
    this.landingPageRepo,
  ) : super(LandingPageInitial());

  void createLandingPage(LandingPage? landingpage, Uint8List imageData,
      bool imageHasChanged, String templateID) async {
    if (landingpage == null) {
      emit(LandingPageShowValidationState());
    } else if (imageData == [0]) {
      emit(LandingPageNoImageFailureState());
    } else if (imageData.lengthInBytes > fileSizeLimit) {
      emit(LandingPageImageExceedsFileSizeLimitFailureState());
    } else {
      emit(CreateLandingPageLoadingState());
      final failureOrSuccess = await landingPageRepo.createLandingPage(
          landingpage, imageData, imageHasChanged, templateID, null);
      failureOrSuccess.fold(
          (failure) => emit(CreateLandingPageFailureState(failure: failure)),
          (_) => emit(CreatedLandingPageSuccessState()));
    }
  }

  void createLandingPageWithAI(LandingPage? landingpage, Uint8List imageData,
      bool imageHasChanged, PagebuilderAiGeneration aiGeneration) async {
    if (landingpage == null) {
      emit(LandingPageShowValidationState());
    } else if (imageData == [0]) {
      emit(LandingPageNoImageFailureState());
    } else if (imageData.lengthInBytes > fileSizeLimit) {
      emit(LandingPageImageExceedsFileSizeLimitFailureState());
    } else {
      emit(CreateLandingPageWithAILoadingState());
      final failureOrSuccess = await landingPageRepo.createLandingPage(
          landingpage, imageData, imageHasChanged, "", aiGeneration);
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

  void checkLandingPageImage(LandingPage? landingPage, Uint8List? imageData) {
    if (landingPage != null && landingPage.thumbnailDownloadURL != null) {
      emit(LandingPageImageValid());
    } else if (imageData == null || imageData == [0]) {
      emit(LandingPageNoImageFailureState());
    } else if (imageData.lengthInBytes > fileSizeLimit) {
      emit(LandingPageImageExceedsFileSizeLimitFailureState());
    } else {
      emit(LandingPageImageValid());
    }
  }

  void checkCompanyData(Company? company) {
    if (company == null) {
      emit(CheckCompanyDataMissingCompanyState());
    } else {
      emit(CheckCompanyValidState());
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

  void toggleLandingPageActivity(
      String id, bool isActive, String userId) async {
    emit(ToggleLandingPageActivityLoadingState());
    final failureOrSuccess =
        await landingPageRepo.toggleLandingPageActivity(id, isActive, userId);
    failureOrSuccess.fold(
        (failure) =>
            emit(ToggleLandingPageActivityFailureState(failure: failure)),
        (_) => emit(ToggleLandingPageActivitySuccessState(isActive: isActive)));
  }

  void getAllLandingPageTemplates() async {
    emit(GetLandingPageTemplatesLoadingState());
    final failureOrSuccess = await landingPageRepo.getAllLandingPageTemplates();
    failureOrSuccess.fold(
        (failure) =>
            emit(GetLandingPageTemplatesFailureState(failure: failure)),
        (templates) =>
            emit(GetLandingPageTemplatesSuccessState(templates: templates)));
  }

  void getPromoters(
      List<String>? associatedUsersIDs, String landingPageID) async {
    emit(GetPromotersLoadingState());
    List<Promoter> promoters = [];
    if (associatedUsersIDs == null || associatedUsersIDs.isEmpty) {
      emit(GetPromotersSuccessState(promoters: promoters));
    } else {
      final failureOrSuccess =
          await landingPageRepo.getUnregisteredPromoters(associatedUsersIDs);
      failureOrSuccess.fold((failure) {
        emit(GetPromotersFailureState(failure: failure));
      }, (unregisteredPromoters) async {
        promoters.addAll(unregisteredPromoters);
        final failureOrSuccessRegistered =
            await landingPageRepo.getRegisteredPromoters(associatedUsersIDs);
        failureOrSuccessRegistered.fold((failure) {
          emit(GetPromotersFailureState(failure: failure));
        }, (registeredPromoters) async {
          promoters.addAll(registeredPromoters);

          final failureOrSuccessLandingPages =
              await landingPageRepo.getLandingPagesForPromoters(promoters);
          failureOrSuccessLandingPages.fold(
              (failure) => emit(GetPromotersFailureState(failure: failure)),
              (landingPages) {
            final updatedPromoters =
                assignLandingPagesToPromoters(promoters, landingPages);
            final promotersWithoutActivePage =
                getPromotersWithoutActiveLandingPagesAfterDeletion(
                    landingPageID, updatedPromoters);
            emit(GetPromotersSuccessState(
                promoters: promotersWithoutActivePage));
          });
        });
      });
    }
  }

  List<Promoter> assignLandingPagesToPromoters(
      List<Promoter> promoters, List<LandingPage> landingPages) {
    final Map<String, LandingPage> landingPageMap = {
      for (var landingPage in landingPages) landingPage.id.value: landingPage,
    };

    return promoters.map((promoter) {
      final associatedLandingPages = promoter.landingPageIDs
              ?.map((id) => landingPageMap[id])
              .whereType<LandingPage>()
              .toList() ??
          [];

      return promoter.copyWith(landingPages: associatedLandingPages);
    }).toList();
  }

  List<Promoter> getPromotersWithoutActiveLandingPagesAfterDeletion(
      String landingPageID, List<Promoter> promoters) {
    return promoters.where((promoter) {
      final updatedLandingPages = (promoter.landingPages ?? [])
          .where((page) => page.id.value != landingPageID)
          .toList();

      final hasNoLandingPages = updatedLandingPages.isEmpty;

      final hasNoActiveLandingPages =
          updatedLandingPages.where((page) => page.isActive == true).isEmpty;

      return hasNoLandingPages || hasNoActiveLandingPages;
    }).toList();
  }

}
