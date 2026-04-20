part of "landing_page_creator_cubit.dart";

class LandingPageCreatorDataState extends Equatable {
  final UniqueID? id;
  final Company? company;
  final LandingPage? landingPage;
  final LandingPageImageData imageData;
  final List<String>? shareImageTemplateUrls;
  final bool showError;
  final bool isEditMode;
  final bool imageValid;
  final bool lastFormButtonsDisabled;
  final bool isLoading;
  final bool isAIGenerating;
  final bool createDefaultPage;
  final String errorMessage;

  const LandingPageCreatorDataState({
    required this.id,
    this.company,
    this.landingPage,
    required this.imageData,
    this.shareImageTemplateUrls,
    this.showError = false,
    required this.isEditMode,
    this.imageValid = false,
    this.lastFormButtonsDisabled = false,
    this.isLoading = false,
    this.isAIGenerating = false,
    required this.createDefaultPage,
    this.errorMessage = "",
  });

  LandingPageCreatorDataState copyWith({
    UniqueID? id,
    Company? company,
    LandingPage? landingPage,
    LandingPageImageData? imageData,
    List<String>? shareImageTemplateUrls,
    bool? showError,
    bool? isEditMode,
    bool? imageValid,
    bool? lastFormButtonsDisabled,
    bool? isLoading,
    bool? isAIGenerating,
    bool? createDefaultPage,
    String? errorMessage,
  }) {
    return LandingPageCreatorDataState(
      id: id ?? this.id,
      company: company ?? this.company,
      landingPage: landingPage ?? this.landingPage,
      imageData: imageData ?? this.imageData,
      shareImageTemplateUrls:
          shareImageTemplateUrls ?? this.shareImageTemplateUrls,
      showError: showError ?? this.showError,
      isEditMode: isEditMode ?? this.isEditMode,
      imageValid: imageValid ?? this.imageValid,
      lastFormButtonsDisabled:
          lastFormButtonsDisabled ?? this.lastFormButtonsDisabled,
      isLoading: isLoading ?? this.isLoading,
      isAIGenerating: isAIGenerating ?? this.isAIGenerating,
      createDefaultPage: createDefaultPage ?? this.createDefaultPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        company,
        landingPage,
        imageData,
        shareImageTemplateUrls,
        showError,
        isEditMode,
        imageValid,
        lastFormButtonsDisabled,
        isLoading,
        isAIGenerating,
        createDefaultPage,
        errorMessage,
      ];
}
