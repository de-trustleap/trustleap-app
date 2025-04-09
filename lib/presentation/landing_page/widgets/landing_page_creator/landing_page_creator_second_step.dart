import 'dart:typed_data';

import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorSecondStep extends StatefulWidget {
  final UniqueID id;
  final LandingPage? landingPage;
  final bool isEditMode;
  final Uint8List? image;
  final bool imageHasChanged;
  final bool buttonsDisabled;
  final bool isLoading;
  final Function(LandingPage, Uint8List?, bool, bool) onContinueTapped;
  final Function(LandingPage) onBack;
  const LandingPageCreatorSecondStep(
      {super.key,
      required this.id,
      required this.landingPage,
      required this.isEditMode,
      required this.image,
      required this.imageHasChanged,
      required this.buttonsDisabled,
      required this.isLoading,
      required this.onContinueTapped,
      required this.onBack});

  @override
  State<LandingPageCreatorSecondStep> createState() =>
      _LandingPageCreatorSecondStepState();
}

class _LandingPageCreatorSecondStepState
    extends State<LandingPageCreatorSecondStep> {
  final impressumTextController = TextEditingController();
  final privacyPolicyTextController = TextEditingController();
  final initialInformationTextController = TextEditingController();
  final termsAndConditionsTextController = TextEditingController();
  final scriptTagsTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validationHasError = false;

  @override
  void initState() {
    super.initState();

    impressumTextController.text = widget.landingPage?.impressum ?? "";
    privacyPolicyTextController.text = widget.landingPage?.privacyPolicy ?? "";
    initialInformationTextController.text =
        widget.landingPage?.initialInformation ?? "";
    termsAndConditionsTextController.text =
        widget.landingPage?.termsAndConditions ?? "";
    scriptTagsTextController.text = widget.landingPage?.scriptTags ?? "";
  }

  String _getSubmitButtonText(AppLocalizations localization) {
    if (widget.isEditMode) {
      return localization.landingpage_creation_edit_button_text;
    } else if (widget.landingPage?.isDefaultPage ?? false) {
      return localization.landingpage_create_buttontitle;
    } else {
      return localization.landingpage_creation_continue;
    }
  }

  @override
  void dispose() {
    impressumTextController.dispose();
    privacyPolicyTextController.dispose();
    initialInformationTextController.dispose();
    termsAndConditionsTextController.dispose();
    scriptTagsTextController.dispose();

    super.dispose();
  }

  void submitContinue() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      widget.onContinueTapped(
          widget.landingPage!.copyWith(
              id: widget.id,
              impressum: impressumTextController.text.trim(),
              privacyPolicy: privacyPolicyTextController.text.trim(),
              initialInformation: initialInformationTextController.text.trim(),
              termsAndConditions: termsAndConditionsTextController.text.trim(),
              scriptTags: scriptTagsTextController.text.trim()),
          widget.image,
          widget.imageHasChanged,
          widget.isEditMode);
    } else {
      validationHasError = true;
      Modular.get<LandingPageCubit>()
          .createLandingPage(null, Uint8List(0), false, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final landingPageCubit = Modular.get<LandingPageCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator =
        LandingPageCreatorFormValidator(localization: localization);
    const double textFieldSpacing = 20;
    return BlocBuilder<LandingPageCubit, LandingPageState>(
        bloc: landingPageCubit,
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(height: responsiveValue.isMobile ? 40 : 80),
              CenteredConstrainedWrapper(
                child: CardContainer(
                    child: LayoutBuilder(builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  return Form(
                      key: formKey,
                      autovalidateMode: state is LandingPageShowValidationState
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(localization.landingpage_create_txt,
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FormTextfield(
                                      maxWidth: maxWidth,
                                      controller: impressumTextController,
                                      disabled: false,
                                      placeholder: localization
                                          .landingpage_creation_impressum_placeholder,
                                      validator: validator
                                          .validateLandingPageImpressum,
                                      minLines: 5,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline)
                                ]),
                            const SizedBox(height: textFieldSpacing),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FormTextfield(
                                      maxWidth: maxWidth,
                                      controller: privacyPolicyTextController,
                                      disabled: false,
                                      placeholder: localization
                                          .landingpage_creation_privacy_policy_placeholder,
                                      validator: validator
                                          .validateLandingPagePrivacyPolicy,
                                      minLines: 5,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline)
                                ]),
                            const SizedBox(height: textFieldSpacing),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FormTextfield(
                                      maxWidth: maxWidth,
                                      controller:
                                          initialInformationTextController,
                                      disabled: false,
                                      placeholder: localization
                                          .landingpage_creation_initial_information_placeholder,
                                      minLines: 5,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline)
                                ]),
                            const SizedBox(height: textFieldSpacing),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FormTextfield(
                                      maxWidth: maxWidth,
                                      controller:
                                          termsAndConditionsTextController,
                                      disabled: false,
                                      placeholder: localization
                                          .landingpage_creation_terms_and_conditions_placeholder,
                                      minLines: 5,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline)
                                ]),
                            const SizedBox(height: textFieldSpacing),
                            SelectableText(
                                localization
                                    .landingpage_creation_scripts_description,
                                style: themeData.textTheme.bodyMedium),
                            const SizedBox(height: textFieldSpacing / 2),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FormTextfield(
                                      maxWidth: maxWidth,
                                      controller: scriptTagsTextController,
                                      disabled: false,
                                      placeholder: localization
                                          .landingpage_creation_scripts_placeholder,
                                      minLines: 5,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline)
                                ]),
                            const SizedBox(height: textFieldSpacing * 2),
                            ResponsiveRowColumn(
                                rowMainAxisAlignment: MainAxisAlignment.center,
                                layout: responsiveValue.largerThan(MOBILE)
                                    ? ResponsiveRowColumnType.ROW
                                    : ResponsiveRowColumnType.COLUMN,
                                children: [
                                  ResponsiveRowColumnItem(
                                    child: SecondaryButton(
                                        title: localization
                                            .landingpage_creation_back_button_text,
                                        disabled: widget.buttonsDisabled,
                                        width: responsiveValue.isMobile
                                            ? maxWidth - textFieldSpacing
                                            : maxWidth / 2 - textFieldSpacing,
                                        onTap: () {
                                          widget.onBack(widget.landingPage!);
                                        }),
                                  ),
                                  const ResponsiveRowColumnItem(
                                      child: SizedBox(
                                          width: textFieldSpacing,
                                          height: textFieldSpacing)),
                                  ResponsiveRowColumnItem(
                                      child: PrimaryButton(
                                          title: _getSubmitButtonText(
                                              localization),
                                          disabled: widget.buttonsDisabled,
                                          isLoading: widget.isLoading,
                                          width: responsiveValue.isMobile
                                              ? maxWidth - textFieldSpacing
                                              : maxWidth / 2 - textFieldSpacing,
                                          onTap: () {
                                            submitContinue();
                                          }))
                                ]),
                          ]));
                })),
              )
            ],
          );
        });
  }
}
