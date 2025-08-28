import 'dart:typed_data';

import 'package:finanzbegleiter/application/calendly/calendly_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/tooltip_buttons/info_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  final calendlyEventUrlController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCalendlyConnected = false;
  bool isConnectingCalendly = false;
  String? calendlyAccessToken;

  @override
  void initState() {
    super.initState();
    selectedBusinessModel =
        widget.landingPage?.businessModel ?? BusinessModel.b2c;
    selectedContactOption =
        widget.landingPage?.contactOption ?? ContactOption.calendly;
    contactEmailController.text = widget.landingPage?.contactEmailAddress ?? "";

    _startObservingCalendlyAuth();
  }

  void _startObservingCalendlyAuth() {
    final calendlyCubit = Modular.get<CalendlyCubit>();
    calendlyCubit.startObservingAuthStatus();
  }

  @override
  void dispose() {
    contactEmailController.dispose();
    calendlyEventUrlController.dispose();

    final calendlyCubit = Modular.get<CalendlyCubit>();
    calendlyCubit.stopObservingAuthStatus();

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

  void _connectCalendly() async {
    final calendlyCubit = Modular.get<CalendlyCubit>();

    setState(() {
      isConnectingCalendly = true;
    });

    // Start OAuth flow by opening popup
    await calendlyCubit.connectToCalendly();

    setState(() {
      isConnectingCalendly = false;
    });
  }

  void _disconnectCalendly() async {
    final calendlyCubit = Modular.get<CalendlyCubit>();
    await calendlyCubit.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator =
        LandingPageCreatorFormValidator(localization: localization);
    final calendlyCubit = Modular.get<CalendlyCubit>();
    final customSnackbar = CustomSnackBar.of(context);

    return BlocListener<CalendlyCubit, CalendlyState>(
      bloc: calendlyCubit,
      listener: (context, state) {
        if (state is CalendlyOAuthReadyState) {
          // Open OAuth URL in new tab using CustomNavigator
          final navigator = CustomNavigator.of(context);
          navigator.openURLInNewTab(state.authUrl);

          // Stream is already observing - no additional action needed
        } else if (state is CalendlyConnectedState) {
          setState(() {
            isCalendlyConnected = true;
            isConnectingCalendly = false;
          });
          customSnackbar.showCustomSnackBar(
            "Calendly erfolgreich verbunden!",
            SnackBarType.success,
          );
        } else if (state is CalendlyAuthenticatedState) {
          setState(() {
            isCalendlyConnected = true;
            isConnectingCalendly = false;
          });
        } else if (state is CalendlyNotAuthenticatedState) {
          setState(() {
            isCalendlyConnected = false;
            isConnectingCalendly = false;
          });
        } else if (state is CalendlyConnectionFailureState) {
          setState(() {
            isConnectingCalendly = false;
          });
          if (!isCalendlyConnected) {
            customSnackbar.showCustomSnackBar(
              "Fehler beim Verbinden mit Calendly",
              SnackBarType.failure,
            );
          }
        } else if (state is CalendlyDisconnectedState) {
          setState(() {
            isCalendlyConnected = false;
            isConnectingCalendly = false;
          });
          customSnackbar.showCustomSnackBar(
            "Calendly erfolgreich getrennt",
            SnackBarType.success,
          );
        } else if (state is CalendlyConnectingState) {
          setState(() {
            isConnectingCalendly = true;
          });
        }
      },
      child: Column(
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
                          "Kontaktmöglichkeit auswählen",
                          style: themeData.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        InfoButton(
                          text:
                              "Wählen Sie aus, wie Interessenten Kontakt zu Ihnen aufnehmen können.",
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
                            title: const Text("Calendly"),
                            value: ContactOption.calendly,
                          ),
                          RadioListTile<ContactOption>(
                            title: const Text("Kontaktformular"),
                            value: ContactOption.constactForm,
                          ),
                          RadioListTile<ContactOption>(
                            title: const Text("Beides"),
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
                      if (isCalendlyConnected) ...[
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Calendly Account erfolgreich verbunden",
                                  style:
                                      themeData.textTheme.bodyMedium!.copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SecondaryButton(
                              title: "Trennen (Test)",
                              disabled: false,
                              width: maxWidth / 3,
                              onTap: _disconnectCalendly,
                            ),
                          ],
                        ),
                      ] else ...[
                        SecondaryButton(
                          title: isConnectingCalendly
                              ? "Verbinde..."
                              : "Verbinde Calendly",
                          disabled: isConnectingCalendly,
                          width: maxWidth / 2,
                          onTap: _connectCalendly,
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormTextfield(
                            maxWidth: maxWidth,
                            controller: calendlyEventUrlController,
                            disabled: false,
                            placeholder:
                                "Calendly Event URL (z.B. https://calendly.com/ihr-name/termin)",
                            validator: (value) {
                              if (_needsCalendly() &&
                                  (value == null || value.trim().isEmpty)) {
                                return "Calendly Event URL ist erforderlich";
                              }
                              if (value != null && value.trim().isNotEmpty) {
                                if (!value.contains('calendly.com/')) {
                                  return "Bitte geben Sie eine gültige Calendly URL ein";
                                }
                              }
                              return null;
                            },
                            keyboardType: TextInputType.url,
                          ),
                        ],
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
      ),
    );
  }
}
