import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_first_step_form.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_image_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorFirstStep extends StatefulWidget {
  final LandingPage? landingPage;
  final Company? company;
  final bool isEditMode;
  final bool createDefaultPage;
  final Function(LandingPage, Uint8List?, bool) onContinue;
  const LandingPageCreatorFirstStep(
      {super.key,
      this.company,
      this.landingPage,
      required this.isEditMode,
      required this.createDefaultPage,
      required this.onContinue});

  @override
  State<LandingPageCreatorFirstStep> createState() =>
      _LandingPageCreatorInputState();
}

class _LandingPageCreatorInputState extends State<LandingPageCreatorFirstStep> {
  late UniqueID id;
  Uint8List? image;
  bool imageHasChanged = false;
  bool showError = false;
  String errorMessage = "";
  int currentPageIndex = 0;
  late LandingPage landingPage;

  @override
  void initState() {
    super.initState();
    id = UniqueID();
  }

  void _onContinue(LandingPage landingPage) {
    this.landingPage = landingPage;
    final landingPageCubit = Modular.get<LandingPageCubit>();
    landingPageCubit.checkLandingPageImage(widget.landingPage, image);
  }

  @override
  Widget build(BuildContext context) {
    final landingPageCubit = Modular.get<LandingPageCubit>();
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return BlocListener<LandingPageCubit, LandingPageState>(
        bloc: landingPageCubit,
        listener: (context, state) {
          if (state is LandingPageNoImageFailureState) {
            setState(() {
              showError = true;
              errorMessage = localization.error_msg_pleace_upload_picture;
            });
          } else if (state
              is LandingPageImageExceedsFileSizeLimitFailureState) {
            setState(() {
              showError = true;
              errorMessage = localization
                  .profile_page_image_section_validation_exceededFileSize;
            });
          } else if (state is LandingPageImageValid) {
            setState(() {
              showError = false;
              errorMessage = "";
            });
            if (widget.createDefaultPage) {
              Modular.get<LandingPageCubit>().checkCompanyData(widget.company);
            } else {
              widget.onContinue(landingPage, image, imageHasChanged);
            }
          } else if (state is CheckCompanyDataMissingCompanyState) {
            setState(() {
              showError = true;
              errorMessage =
                  localization.landingpage_creator_missing_companydata_error;
            });
          } else if (state is CheckCompanyValidState) {
            setState(() {
              showError = false;
              errorMessage = "";
            });
            widget.onContinue(landingPage, image, imageHasChanged);
          }
        },
        child: Column(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          LandingPageCreatorImageSection(
              id: id,
              landingPage: widget.landingPage,
              isEditMode: widget.isEditMode,
              company: widget.company,
              imageSelected: (tempImage) {
                image = tempImage;
                imageHasChanged = true;
              }),
          const SizedBox(height: 20),
          CenteredConstrainedWrapper(
              child: LandingPageCreatorFirstStepForm(
            id: id,
            landingPage: widget.landingPage,
            company: widget.company,
            createDefaultPage: widget.createDefaultPage,
            onContinueTap: (landingPage) {
              _onContinue(landingPage);
            },
          )),
          if (showError && errorMessage != "") ...[
            const SizedBox(height: 20),
            CenteredConstrainedWrapper(
                child: FormErrorView(message: errorMessage))
          ],
        ]));
  }
}
