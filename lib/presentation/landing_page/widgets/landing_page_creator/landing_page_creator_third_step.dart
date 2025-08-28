import 'dart:typed_data';

import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/tooltip_buttons/info_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/calendly_connection_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorThirdStep extends StatefulWidget {
  final LandingPage? landingPage;
  final Uint8List? image;
  final bool imageHasChanged;
  final bool buttonsDisabled;
  final bool isLoading;
  final Function(LandingPage) onBack;
  final Function(LandingPage, Uint8List?, bool) onContinue;

  const LandingPageCreatorThirdStep({
    super.key,
    required this.landingPage,
    required this.image,
    required this.imageHasChanged,
    required this.buttonsDisabled,
    required this.isLoading,
    required this.onBack,
    required this.onContinue,
  });

  @override
  State<LandingPageCreatorThirdStep> createState() =>
      _LandingPageCreatorThirdStepState();
}

class _LandingPageCreatorThirdStepState
    extends State<LandingPageCreatorThirdStep> {
  BusinessModel? selectedBusinessModel;
  ContactOption? selectedContactOption;
  final contactEmailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedEventTypeUrl;

  @override
  void initState() {
    super.initState();
    selectedBusinessModel =
        widget.landingPage?.businessModel ?? BusinessModel.b2c;
    selectedContactOption =
        widget.landingPage?.contactOption ?? ContactOption.calendly;
    contactEmailController.text = widget.landingPage?.contactEmailAddress ?? "";
    selectedEventTypeUrl = widget.landingPage?.calendlyEventURL;
  }

  @override
  void dispose() {
    contactEmailController.dispose();
    super.dispose();
  }

  void _onContinue() {
    bool isValid = true;

    // Validate form if contact form or calendly is selected
    if ((_needsContactEmail() || _needsCalendly()) &&
        formKey.currentState != null) {
      isValid = formKey.currentState!.validate();
    }

    if (selectedBusinessModel != null &&
        selectedContactOption != null &&
        isValid) {
      final updatedLandingPage = widget.landingPage?.copyWith(
        businessModel: selectedBusinessModel,
        contactOption: selectedContactOption,
        contactEmailAddress: contactEmailController.text.trim(),
        calendlyEventURL: selectedEventTypeUrl,
      );
      if (updatedLandingPage != null) {
        widget.onContinue(
            updatedLandingPage, widget.image, widget.imageHasChanged);
      }
    }
  }

  bool _needsContactEmail() {
    return selectedContactOption == ContactOption.constactForm ||
        selectedContactOption == ContactOption.both;
  }

  bool _needsCalendly() {
    return selectedContactOption == ContactOption.calendly ||
        selectedContactOption == ContactOption.both;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator =
        LandingPageCreatorFormValidator(localization: localization);

    return Column(
        children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          CenteredConstrainedWrapper(
            child: CardContainer(
              maxWidth: 800,
              child: LayoutBuilder(builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                return Form(
                  key: formKey,
                  child: Column(children: [
                    Row(
                      children: [
                        SelectableText(
                          localization.landingpage_creator_business_model_title,
                          style: themeData.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        InfoButton(
                          text: localization
                              .landingpage_creator_business_model_info_tooltip,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RadioGroup<BusinessModel>(
                      groupValue: selectedBusinessModel,
                      onChanged: (BusinessModel? value) {
                        setState(() {
                          selectedBusinessModel = value;
                        });
                      },
                      child: Column(
                        children: [
                          RadioListTile<BusinessModel>(
                            title: Text(localization
                                .landingpage_creator_business_model_b2b_label),
                            value: BusinessModel.b2b,
                          ),
                          RadioListTile<BusinessModel>(
                            title: Text(localization
                                .landingpage_creator_business_model_b2c_label),
                            value: BusinessModel.b2c,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        SelectableText(
                          localization.landingpage_creator_contact_option_title,
                          style: themeData.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        InfoButton(
                          text:
                              localization.landingpage_creator_contact_option_info,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RadioGroup<ContactOption>(
                      groupValue: selectedContactOption,
                      onChanged: (ContactOption? value) {
                        setState(() {
                          selectedContactOption = value;
                        });
                      },
                      child: Column(
                        children: [
                          RadioListTile<ContactOption>(
                            title: Text(localization.landingpage_creator_contact_option_calendly),
                            value: ContactOption.calendly,
                          ),
                          RadioListTile<ContactOption>(
                            title: Text(localization.landingpage_creator_contact_option_form),
                            value: ContactOption.constactForm,
                          ),
                          RadioListTile<ContactOption>(
                            title: Text(localization.landingpage_creator_contact_option_both),
                            value: ContactOption.both,
                          ),
                        ],
                      ),
                    ),
                    if (_needsContactEmail()) ...[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormTextfield(
                            maxWidth: maxWidth,
                            controller: contactEmailController,
                            disabled: false,
                            placeholder: localization
                                .landingpage_creator_placeholder_contact_email,
                            validator: validator
                                .validateLandingPageContactEmailAddress,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ],
                    if (_needsCalendly()) ...[
                      const SizedBox(height: 20),
                      CalendlyConnectionWidget(
                        isRequired: true,
                        selectedEventTypeUrl: selectedEventTypeUrl,
                        onEventTypeSelected: (String? newValue) {
                          setState(() {
                            selectedEventTypeUrl = newValue;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 48),
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
                                ? maxWidth - 20
                                : maxWidth / 2 - 20,
                            onTap: () {
                              widget.onBack(widget.landingPage!);
                            },
                          ),
                        ),
                        const ResponsiveRowColumnItem(
                            child: SizedBox(width: 20, height: 20)),
                        ResponsiveRowColumnItem(
                          child: PrimaryButton(
                            title: localization.landingpage_creation_continue,
                            disabled: widget.buttonsDisabled ||
                                selectedBusinessModel == null ||
                                selectedContactOption == null,
                            isLoading: widget.isLoading,
                            width: responsiveValue.isMobile
                                ? maxWidth - 20
                                : maxWidth / 2 - 20,
                            onTap: _onContinue,
                          ),
                        ),
                      ],
                    ),
                  ]),
                );
              }),
            ),
          ),
        ],
      );
  }
}
