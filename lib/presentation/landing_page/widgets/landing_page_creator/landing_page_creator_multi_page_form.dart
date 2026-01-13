import 'package:finanzbegleiter/application/landingpages/landing_page_creator/landing_page_creator_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_overlay.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_first_step.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_fourth_step.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_progress_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_second_step.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_third_step.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorMultiPageForm extends StatefulWidget {
  final LandingPage? landingPage;
  final bool createDefaultPage;
  const LandingPageCreatorMultiPageForm(
      {super.key, required this.landingPage, required this.createDefaultPage});

  @override
  State<LandingPageCreatorMultiPageForm> createState() =>
      _LandingPageCreatorMultiPageFormState();
}

class _LandingPageCreatorMultiPageFormState
    extends State<LandingPageCreatorMultiPageForm> {
  late List<Widget> _steps;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();

    final creatorCubit = Modular.get<LandingPageCreatorCubit>();

    if (widget.landingPage != null) {
      // Always initialize when we have landingPage data - could be a different landing page
      creatorCubit.initialize(
        landingPage: widget.landingPage,
        createDefaultPage: widget.createDefaultPage,
      );
    } else if (creatorCubit.state.landingPage == null) {
      // Initialize empty state only if cubit has no data
      creatorCubit.initialize(
        landingPage: null,
        createDefaultPage: widget.createDefaultPage,
      );
    }

    Modular.to.addListener(_onRouteChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = Modular.get<UserObserverCubit>().state;
      if (userState is UserObserverSuccess &&
          userState.user.companyID != null) {
        Modular.get<CompanyCubit>().getCompany(userState.user.companyID!);
      }

      final currentRoute = Modular.to.path;
      if (!currentRoute.contains(RoutePaths.landingPageCreatorStep1Path)) {
        Modular.to.navigate(RoutePaths.homePath +
            RoutePaths.landingPageCreatorPath +
            RoutePaths.landingPageCreatorStep1Path);
      }
      _updateCurrentStep();
    });
  }

  @override
  void dispose() {
    Modular.to.removeListener(_onRouteChanged);

    // Only reset cubit when actually leaving the creator page
    // (not when just navigating between steps)
    final currentRoute = Modular.to.path;
    if (!currentRoute.contains(RoutePaths.landingPageCreatorPath)) {
      Modular.get<LandingPageCreatorCubit>().reset();
    }

    super.dispose();
  }

  void _onRouteChanged() {
    _updateCurrentStep();
  }

  void _updateCurrentStep() {
    final newStep = _getCurrentStepFromRoute();
    if (mounted && newStep != _currentStep) {
      setState(() {
        _currentStep = newStep;
      });
    }
  }

  int _getCurrentStepFromRoute() {
    final currentRoute = Modular.to.path;
    if (currentRoute.contains(RoutePaths.landingPageCreatorStep1Path)) {
      return 0;
    } else if (currentRoute.contains(RoutePaths.landingPageCreatorStep2Path)) {
      return 1;
    } else if (currentRoute.contains(RoutePaths.landingPageCreatorStep3Path)) {
      return 2;
    } else if (currentRoute.contains(RoutePaths.landingPageCreatorStep4Path)) {
      return 3;
    }
    return 0;
  }

  void _initializeSteps(LandingPageCreatorDataState creatorState) {
    final creatorCubit = Modular.get<LandingPageCreatorCubit>();
    _steps = [
      LandingPageCreatorFirstStep(
          key: ValueKey('step1_${creatorState.landingPage?.id.value ?? "new"}'),
          landingPage: creatorState.landingPage,
          isEditMode: creatorState.isEditMode,
          createDefaultPage: widget.createDefaultPage,
          company: creatorState.company,
          onContinue: (landingPage, image, imageHasChanged) {
            final currentState = creatorCubit.state;
            if (currentState.imageValid) {
              creatorCubit.updateLandingPage(widget.createDefaultPage
                  ? landingPage.copyWith(isDefaultPage: true)
                  : landingPage.copyWith(isDefaultPage: false));
              creatorCubit.updateImage(image, imageHasChanged);
              Modular.to.navigate(RoutePaths.homePath +
                  RoutePaths.landingPageCreatorPath +
                  RoutePaths.landingPageCreatorStep2Path);
            }
          }),
      LandingPageCreatorSecondStep(
          id: creatorState.isEditMode
              ? (creatorState.landingPage?.id ?? UniqueID())
              : (creatorState.id ?? UniqueID()),
          landingPage: creatorState.landingPage,
          image: creatorState.image,
          imageHasChanged: creatorState.imageHasChanged,
          buttonsDisabled: creatorState.lastFormButtonsDisabled,
          isLoading: creatorState.isLoading,
          isEditMode: creatorState.isEditMode,
          onContinueTapped: (landingPage, image, imageHasChanged, isEditMode) {
            final currentState = creatorCubit.state;
            if (currentState.isEditMode &&
                (landingPage.isDefaultPage ?? false)) {
              Modular.get<LandingPageCubit>()
                  .editLandingPage(landingPage, image, imageHasChanged);
            } else if (currentState.isEditMode &&
                !(landingPage.isDefaultPage ?? false)) {
              creatorCubit.updateImage(image, imageHasChanged);
              creatorCubit.updateLandingPage(landingPage);
              Modular.to.navigate(RoutePaths.homePath +
                  RoutePaths.landingPageCreatorPath +
                  RoutePaths.landingPageCreatorStep3Path);
            } else if ((landingPage.isDefaultPage ?? false) && image != null) {
              Modular.get<LandingPageCubit>()
                  .createLandingPage(landingPage, image, imageHasChanged, "");
            } else if (image != null) {
              creatorCubit.updateImage(image, imageHasChanged);
              creatorCubit.updateLandingPage(landingPage);
              Modular.to.navigate(RoutePaths.homePath +
                  RoutePaths.landingPageCreatorPath +
                  RoutePaths.landingPageCreatorStep3Path);
            }
          },
          onBack: (landingPage) {
            creatorCubit.updateLandingPage(landingPage);
            Modular.to.navigate(RoutePaths.homePath +
                RoutePaths.landingPageCreatorPath +
                RoutePaths.landingPageCreatorStep1Path);
          }),
      if (!widget.createDefaultPage)
        LandingPageCreatorThirdStep(
            landingPage: creatorState.landingPage,
            image: creatorState.image,
            imageHasChanged: creatorState.imageHasChanged,
            buttonsDisabled: creatorState.lastFormButtonsDisabled,
            isLoading: creatorState.isLoading,
            isEditMode: creatorState.isEditMode,
            onBack: (landingPage) {
              creatorCubit.updateLandingPage(landingPage);
              Modular.to.navigate(RoutePaths.homePath +
                  RoutePaths.landingPageCreatorPath +
                  RoutePaths.landingPageCreatorStep2Path);
            },
            onContinue: (landingPage, image, imageHasChanged) {
              creatorCubit.updateLandingPage(landingPage);
              creatorCubit.updateImage(image, imageHasChanged);
              Modular.to.navigate(RoutePaths.homePath +
                  RoutePaths.landingPageCreatorPath +
                  RoutePaths.landingPageCreatorStep4Path);
            }),
      if (!widget.createDefaultPage && !creatorState.isEditMode)
        LandingPageCreatorFourthStep(
            landingPage: creatorState.landingPage,
            image: creatorState.image,
            imageHasChanged: creatorState.imageHasChanged,
            buttonsDisabled: creatorState.lastFormButtonsDisabled,
            isLoading: creatorState.isLoading,
            onBack: (landingPage) {
              creatorCubit.updateLandingPage(landingPage);
              Modular.to.navigate(RoutePaths.homePath +
                  RoutePaths.landingPageCreatorPath +
                  RoutePaths.landingPageCreatorStep3Path);
            },
            onSaveTapped: (landingPage, image, imageHasChanged, templateID) {
              if (image != null) {
                Modular.get<LandingPageCubit>().createLandingPage(
                    landingPage, image, imageHasChanged, templateID);
              }
            },
            onAISaveTapped: (landingPage, image, imageHasChanged, aiData) {
              if (image != null) {
                Modular.get<LandingPageCubit>().createLandingPageWithAI(
                    landingPage, image, imageHasChanged, aiData);
              }
            })
    ];
  }

  @override
  Widget build(BuildContext context) {
    final landingPageCubit = Modular.get<LandingPageCubit>();
    final creatorCubit = Modular.get<LandingPageCreatorCubit>();
    final companyCubit = Modular.get<CompanyCubit>();
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final navigator = CustomNavigator.of(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<UserObserverCubit, UserObserverState>(
              bloc: Modular.get<UserObserverCubit>(),
              listener: (context, state) {
                if (state is UserObserverSuccess &&
                    state.user.companyID != null) {
                  companyCubit.getCompany(state.user.companyID!);
                }
              }),
          BlocListener<LandingPageCubit, LandingPageState>(
              bloc: landingPageCubit,
              listener: (context, state) {
                if (state is CreatedLandingPageSuccessState) {
                  creatorCubit.clearError();
                  creatorCubit.setAIGenerating(false);
                  const params = "?createdNewPage=true";
                  final landingPage = creatorCubit.state.landingPage;
                  if ((landingPage?.isDefaultPage == null ||
                          landingPage?.isDefaultPage == false) &&
                      responsiveValue.isDesktop) {
                    navigator.openInNewTab(
                        "${RoutePaths.homePath}${RoutePaths.landingPageBuilderPath}/${landingPage?.id.value}");
                  }
                  navigator.navigate(RoutePaths.homePath +
                      RoutePaths.landingPagePath +
                      params);
                } else if (state is EditLandingPageSuccessState) {
                  creatorCubit.clearError();
                  const params = "?editedPage=true";
                  navigator.pushAndReplace(
                      RoutePaths.homePath + RoutePaths.landingPagePath, params);
                } else if (state is LandingPageNoImageFailureState) {
                  creatorCubit.setImageValid(false);
                } else if (state
                    is LandingPageImageExceedsFileSizeLimitFailureState) {
                  creatorCubit.setImageValid(false);
                } else if (state is LandingPageImageValid) {
                  creatorCubit.setImageValid(true);
                } else if (state is CreateLandingPageFailureState) {
                  creatorCubit.setError(DatabaseFailureMapper.mapFailureMessage(
                      state.failure, localization));
                  creatorCubit.setLastFormButtonsDisabled(false);
                  creatorCubit.setLoading(false);
                  creatorCubit.setAIGenerating(false);
                } else if (state is EditLandingPageFailureState) {
                  creatorCubit.setError(DatabaseFailureMapper.mapFailureMessage(
                      state.failure, localization));
                  creatorCubit.setLastFormButtonsDisabled(false);
                  creatorCubit.setLoading(false);
                } else if (state is CreateLandingPageLoadingState ||
                    state is EditLandingPageLoadingState) {
                  creatorCubit.setLastFormButtonsDisabled(true);
                  creatorCubit.setLoading(true);
                } else if (state is CreateLandingPageWithAILoadingState) {
                  creatorCubit.setAIGenerating(true);
                } else if (state is GetLandingPageTemplatesFailureState) {
                  creatorCubit.setError(DatabaseFailureMapper.mapFailureMessage(
                      state.failure, localization));
                  creatorCubit.setLastFormButtonsDisabled(false);
                } else {
                  creatorCubit.clearError();
                }
              }),
          BlocListener<CompanyCubit, CompanyState>(
              bloc: companyCubit,
              listener: (context, state) {
                if (state is GetCompanySuccessState) {
                  creatorCubit.setCompany(state.company);
                }
              })
        ],
        child:
            BlocBuilder<LandingPageCreatorCubit, LandingPageCreatorDataState>(
          bloc: creatorCubit,
          builder: (context, creatorState) {
            _initializeSteps(creatorState);
            final progress = (_currentStep + 1) / _steps.length;

            return Stack(
              children: [
                ListView(children: [
                  _steps[_currentStep],
                  const SizedBox(height: 20),
                  LandingPageCreatorProgressIndicator(
                      progress: progress, elementsTotal: _steps.length),
                  SizedBox(height: responsiveValue.isMobile ? 50 : 100),
                  if (creatorState.errorMessage.isNotEmpty &&
                      creatorState.showError) ...[
                    const SizedBox(height: 20),
                    CenteredConstrainedWrapper(
                        child:
                            FormErrorView(message: creatorState.errorMessage))
                  ]
                ]),
                if (creatorState.isAIGenerating)
                  LoadingOverlay(
                    title: localization.landingpage_creator_ai_loading_subtitle,
                    subtitle:
                        localization.landingpage_creator_ai_loading_subtitle2,
                  ),
              ],
            );
          },
        ));
  }
}
