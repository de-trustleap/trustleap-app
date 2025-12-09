import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';

part 'landing_page_creator_state.dart';

class LandingPageCreatorCubit extends Cubit<LandingPageCreatorDataState> {
  LandingPageCreatorCubit()
      : super(const LandingPageCreatorDataState(
          id: null,
          isEditMode: false,
          createDefaultPage: false,
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
    ));
  }

  void setCompany(Company company) {
    emit(state.copyWith(company: company));
  }

  void updateLandingPage(LandingPage landingPage) {
    emit(state.copyWith(landingPage: landingPage));
  }

  void updateImage(Uint8List? image, bool imageHasChanged) {
    emit(state.copyWith(
      image: image,
      imageHasChanged: imageHasChanged,
    ));
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
      errorMessage: '',
    ));
  }

  void reset() {
    emit(const LandingPageCreatorDataState(
      id: null,
      isEditMode: false,
      createDefaultPage: false,
    ));
  }
}
