import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_image_section.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorInput extends StatefulWidget {
  final LandingPage? landingPage;
  const LandingPageCreatorInput({super.key, this.landingPage});

  @override
  State<LandingPageCreatorInput> createState() =>
      _LandingPageCreatorInputState();
}

class _LandingPageCreatorInputState extends State<LandingPageCreatorInput> {
  late UniqueID id;
  Company? company;
  Uint8List? image;
  bool imageHasChanged = false;
  bool showError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    id = UniqueID();
    BlocProvider.of<LandingPageCubit>(context).getUser();
  }

  void onSubmitCreate(LandingPage? landingPage, Function completion,
      AppLocalizations localization) {
    if (image != null || company?.companyImageDownloadURL != null) {
      setState(() {
        showError = false;
      });
      completion();
    } else {
      setState(() {
        showError = true;
        errorMessage = localization.error_msg_pleace_upload_picture;
      });
    }
  }

  void onSubmitEdit(LandingPage? landingPage, Function completion,
      AppLocalizations localization) {
    if (landingPage?.thumbnailDownloadURL != null) {
      setState(() {
        showError = false;
      });
      completion();
    } else {
      setState(() {
        showError = true;
        errorMessage = localization.error_msg_pleace_upload_picture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<LandingPageCubit, LandingPageState>(
              listener: (context, state) {
            if (state is CreatedLandingPageSuccessState) {
              showError = false;
              const params = "?createdNewPage=true";
              Modular.to.navigate(
                  RoutePaths.homePath + RoutePaths.landingPagePath + params);
            } else if (state is EditLandingPageSuccessState) {
              showError = false;
              const params = "?editedPage=true";
              Modular.to.navigate(
                  RoutePaths.homePath + RoutePaths.landingPagePath + params);
            } else if (state is GetUserSuccessState) {
              showError = false;
              if (state.user.companyID != null) {
                BlocProvider.of<CompanyCubit>(context)
                    .getCompany(state.user.companyID!);
              }
            } else if (state
                is LandingPageImageExceedsFileSizeLimitFailureState) {
              showError = true;
              errorMessage = localization
                  .profile_page_image_section_validation_exceededFileSize;
            } else if (state is LandingPageNoImageFailureState) {
              showError = true;
              errorMessage = "Bitte ein Bild hochladen";
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
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: themeData.colorScheme.surface),
            child: ListView(children: [
              SizedBox(height: responsiveValue.isMobile ? 40 : 80),
              LandingPageCreatorImageSection(
                  id: id,
                  landingPage: widget.landingPage,
                  company: company,
                  imageSelected: (tempImage) {
                    image = tempImage;
                    imageHasChanged = true;
                  }),
              const SizedBox(height: 20),
              CenteredConstrainedWrapper(
                  child: LandingPageCreatorForm(
                id: id,
                landingPage: widget.landingPage,
                onSaveTap: (landingPage) {
                  onSubmitCreate(
                      landingPage,
                      () => BlocProvider.of<LandingPageCubit>(context)
                          .createLandingPage(
                              landingPage, image!, imageHasChanged),
                      localization);
                },
                onEditTapped: (landingPage) {
                  onSubmitEdit(landingPage, () {
                    BlocProvider.of<LandingPageCubit>(context)
                        .editLandingPage(landingPage, image, imageHasChanged);
                  }, localization);
                },
              )),
              if (showError && errorMessage != "") ...[
                const SizedBox(height: 20),
                CenteredConstrainedWrapper(
                    child: FormErrorView(message: errorMessage))
              ]
            ])));
  }
}
