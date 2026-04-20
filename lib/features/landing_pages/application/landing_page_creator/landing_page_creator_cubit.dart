import "dart:typed_data";

import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";
import "package:finanzbegleiter/features/profile/domain/company.dart";
import "package:finanzbegleiter/core/id.dart";
import "package:finanzbegleiter/features/landing_pages/domain/landing_page.dart";
import "package:finanzbegleiter/features/landing_pages/domain/landing_page_image_data.dart";
import "package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart";

part "landing_page_creator_state.dart";

class LandingPageCreatorCubit extends Cubit<LandingPageCreatorDataState> {
  final LandingPageRepository landingPageRepo;

  LandingPageCreatorCubit(this.landingPageRepo)
      : super(const LandingPageCreatorDataState(
          id: null,
          isEditMode: false,
          createDefaultPage: false,
          imageData: LandingPageImageData.empty(),
        ));

  void initialize({
    LandingPage? landingPage,
    bool createDefaultPage = false,
  }) {
    final isEditMode = landingPage != null;
    emit(LandingPageCreatorDataState(
      id: isEditMode ? landingPage.id : null,
      landingPage: landingPage,
      isEditMode: isEditMode,
      createDefaultPage: createDefaultPage,
      imageData: const LandingPageImageData.empty(),
    ));
  }

  void setCompany(Company company) {
    emit(state.copyWith(company: company));
  }

  void updateLandingPage(LandingPage landingPage) {
    emit(state.copyWith(landingPage: landingPage));
  }

  void updateMainImage(Uint8List? image, bool imageHasChanged) {
    emit(state.copyWith(
      imageData: state.imageData.copyWith(
        mainImage: image,
        mainImageHasChanged: imageHasChanged,
      ),
    ));
  }

  void updateFaviconImage(Uint8List? image, bool hasChanged) {
    emit(state.copyWith(
      imageData: state.imageData.copyWith(
        faviconImage: image,
        faviconImageHasChanged: hasChanged,
      ),
    ));
  }

  void updateShareImage(Uint8List? image, bool hasChanged) {
    emit(state.copyWith(
      imageData: state.imageData.copyWith(
        shareImage: image,
        shareImageHasChanged: hasChanged,
      ),
    ));
  }

  Future<void> loadShareImageTemplates() async {
    final result = await landingPageRepo.getShareImageTemplateUrls();
    result.fold(
      (_) => null,
      (urls) => emit(state.copyWith(shareImageTemplateUrls: urls)),
    );
  }

  void setImageValid(bool isValid) {
    emit(state.copyWith(imageValid: isValid));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setAIGenerating(bool isGenerating) {
    emit(state.copyWith(isAIGenerating: isGenerating));
  }

  void setLastFormButtonsDisabled(bool disabled) {
    emit(state.copyWith(lastFormButtonsDisabled: disabled));
  }

  void setError(String errorMessage) {
    emit(state.copyWith(
      showError: true,
      errorMessage: errorMessage,
    ));
  }

  void clearError() {
    emit(state.copyWith(
      showError: false,
      errorMessage: "",
    ));
  }

  void reset() {
    emit(const LandingPageCreatorDataState(
      id: null,
      isEditMode: false,
      createDefaultPage: false,
      imageData: LandingPageImageData.empty(),
    ));
  }
}
