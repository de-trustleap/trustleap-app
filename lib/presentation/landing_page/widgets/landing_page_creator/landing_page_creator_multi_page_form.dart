import 'dart:typed_data';

import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_first_step.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_progress_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_second_step.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_third_step.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorMultiPageForm extends StatefulWidget {
  final LandingPage? landingPage;
  const LandingPageCreatorMultiPageForm({super.key, required this.landingPage});

  @override
  State<LandingPageCreatorMultiPageForm> createState() =>
      _LandingPageCreatorMultiPageFormState();
}

class _LandingPageCreatorMultiPageFormState
    extends State<LandingPageCreatorMultiPageForm> {
  int _currentStep = 0;
  late UniqueID id;
  Company? company;
  Uint8List? image;
  bool imageHasChanged = false;
  bool showError = false;
  bool isEditMode = false;
  bool imageValid = false;
  bool lastFormButtonsDisabled = false;
  bool isLoading = false;
  late double progress;
  String errorMessage = "";
  LandingPage? landingPage;

  late List<Widget> _steps;

  @override
  void initState() {
    super.initState();
    id = UniqueID();

    isEditMode = widget.landingPage != null;
    landingPage = widget.landingPage;

    BlocProvider.of<LandingPageCubit>(context).getUser();
    _initializeSteps();

    progress = 1 / _steps.length;
  }

  void _initializeSteps() {
    if (isEditMode) {
      _initializeStepsForEditing();
    } else {
      _initializeStepsForCreation();
    }
  }

  void _initializeStepsForCreation() {
    _steps = [
      LandingPageCreatorFirstStep(
          landingPage: landingPage,
          isEditMode: isEditMode,
          company: company,
          onContinue: (landingPage, image) {
            if (imageValid) {
              setState(() {
                this.image = image;
                this.landingPage = landingPage;
                _currentStep += 1;
                progress = 2 / _steps.length;
              });
            }
          }),
      LandingPageCreatorSecondStep(
          id: isEditMode ? (widget.landingPage?.id ?? UniqueID()) : id,
          landingPage: landingPage,
          image: image,
          imageHasChanged: imageHasChanged,
          buttonsDisabled: lastFormButtonsDisabled,
          isLoading: isLoading,
          isEditMode: isEditMode,
          onContinueTapped: (landingPage, image, imageHasChanged, isEditMode) {
            if (isEditMode) {
              BlocProvider.of<LandingPageCubit>(context)
                  .editLandingPage(landingPage, image, imageHasChanged);
            } else if (image != null) {
              setState(() {
                this.image = image;
                this.landingPage = landingPage;
                _currentStep += 1;
                progress = 3 / _steps.length;
              });
            }
          },
          onBack: (landingPage) {
            setState(() {
              this.landingPage = landingPage;
              _currentStep -= 1;
              progress = 1 / _steps.length;
            });
          }),
      LandingPageCreatorThirdStep(
          landingPage: landingPage,
          image: image,
          imageHasChanged: imageHasChanged,
          buttonsDisabled: lastFormButtonsDisabled,
          isLoading: isLoading,
          onBack: (landingPage) {
            setState(() {
              this.landingPage = landingPage;
              _currentStep -= 1;
              progress = 2 / _steps.length;
            });
          },
          onSaveTapped: (landingPage, image, imageHasChanged, templateID) {
            if (image != null) {
              BlocProvider.of<LandingPageCubit>(context).createLandingPage(
                  landingPage, image, imageHasChanged, templateID);
            }
          })
    ];
  }

  void _initializeStepsForEditing() {
    _steps = [
      LandingPageCreatorFirstStep(
          landingPage: landingPage,
          isEditMode: isEditMode,
          company: company,
          onContinue: (landingPage, image) {
            if (imageValid) {
              setState(() {
                this.image = image;
                this.landingPage = landingPage;
                _currentStep += 1;
                progress = 2 / _steps.length;
              });
            }
          }),
      LandingPageCreatorSecondStep(
          id: isEditMode ? (widget.landingPage?.id ?? UniqueID()) : id,
          landingPage: landingPage,
          image: image,
          imageHasChanged: imageHasChanged,
          buttonsDisabled: lastFormButtonsDisabled,
          isLoading: isLoading,
          isEditMode: isEditMode,
          onContinueTapped: (landingPage, image, imageHasChanged, isEditMode) {
            if (isEditMode) {
              BlocProvider.of<LandingPageCubit>(context)
                  .editLandingPage(landingPage, image, imageHasChanged);
            } else if (image != null) {
              setState(() {
                this.image = image;
                this.landingPage = landingPage;
                _currentStep += 1;
                progress = 3 / _steps.length;
              });
            }
          },
          onBack: (landingPage) {
            setState(() {
              this.landingPage = landingPage;
              _currentStep -= 1;
              progress = 1 / _steps.length;
            });
          })
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    _initializeSteps();
    return MultiBlocListener(
        listeners: [
          BlocListener<LandingPageCubit, LandingPageState>(
              listener: (context, state) {
            if (state is CreatedLandingPageSuccessState) {
              showError = false;
              const params = "?createdNewPage=true";
              CustomNavigator.openInNewTab(
                  "${RoutePaths.homePath}${RoutePaths.landingPageBuilderPath}/${landingPage?.id.value}");
              CustomNavigator.navigate(
                  RoutePaths.homePath + RoutePaths.landingPagePath + params);
            } else if (state is EditLandingPageSuccessState) {
              showError = false;
              const params = "?editedPage=true";
              CustomNavigator.navigate(
                  RoutePaths.homePath + RoutePaths.landingPagePath + params);
            } else if (state is GetUserSuccessState) {
              showError = false;
              if (state.user.companyID != null) {
                BlocProvider.of<CompanyCubit>(context)
                    .getCompany(state.user.companyID!);
              }
            } else if (state is LandingPageNoImageFailureState) {
              setState(() {
                imageValid = false;
              });
            } else if (state
                is LandingPageImageExceedsFileSizeLimitFailureState) {
              setState(() {
                imageValid = false;
              });
            } else if (state is LandingPageImageValid) {
              setState(() {
                imageValid = true;
              });
            } else if (state is CreateLandingPageFailureState) {
              setState(() {
                showError = true;
                errorMessage = DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization);
                lastFormButtonsDisabled = false;
              });
            } else if (state is EditLandingPageFailureState) {
              setState(() {
                showError = true;
                errorMessage = DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization);
                lastFormButtonsDisabled = false;
              });
            } else if (state is CreateLandingPageLoadingState ||
                state is EditLandingPageLoadingState) {
              setState(() {
                lastFormButtonsDisabled = true;
                isLoading = true;
              });
            } else if (state is GetLandingPageTemplatesFailureState) {
              setState(() {
                showError = true;
                errorMessage = DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization);
                lastFormButtonsDisabled = false;
              });
            } else {
              showError = false;
            }
          }),
          BlocListener<CompanyCubit, CompanyState>(listener: (context, state) {
            if (state is GetCompanySuccessState) {
              setState(() {
                company = state.company;
              });
            }
          })
        ],
        child: BlocBuilder<LandingPageCubit, LandingPageState>(
          builder: (context, state) {
            return ListView(children: [
              _steps[_currentStep],
              const SizedBox(height: 20),
              LandingPageCreatorProgressIndicator(
                  progress: progress, elementsTotal: _steps.length),
              SizedBox(height: responsiveValue.isMobile ? 50 : 100),
              if (errorMessage.isNotEmpty && showError == true) ...[
                const SizedBox(height: 20),
                CenteredConstrainedWrapper(
                    child: FormErrorView(message: errorMessage))
              ]
            ]);
          },
        ));
  }
}
