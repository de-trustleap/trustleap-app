// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_emoji_picker.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form_validator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_placeholder_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorFirstStepForm extends StatefulWidget {
  final UniqueID id;
  final LandingPage? landingPage;
  final Function(LandingPage) onContinueTap;
  const LandingPageCreatorFirstStepForm(
      {super.key,
      required this.id,
      this.landingPage,
      required this.onContinueTap});

  @override
  State<LandingPageCreatorFirstStepForm> createState() =>
      _LandingPageCreatorFormState();
}

class _LandingPageCreatorFormState
    extends State<LandingPageCreatorFirstStepForm> {
  final nameTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final contactEmailAddressTextController = TextEditingController();
  final promotionTemplateTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomUser? user;

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;
  bool _isEmojiPickerExpanded = false;

  @override
  void initState() {
    super.initState();
    Modular.get<LandingPageCubit>().getUser();
    if (widget.landingPage != null) {
      nameTextController.text = widget.landingPage?.name ?? "";
      descriptionTextController.text = widget.landingPage?.description ?? "";
      contactEmailAddressTextController.text =
          widget.landingPage?.contactEmailAddress ?? "";
      promotionTemplateTextController.text =
          widget.landingPage?.promotionTemplate ?? "";
    }
  }

  @override
  void dispose() {
    nameTextController.dispose();
    descriptionTextController.dispose();
    contactEmailAddressTextController.dispose();
    promotionTemplateTextController.dispose();

    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void setButtonToDisabled(bool disabled) {
    setState(() {
      buttonDisabled = disabled;
    });
  }

  void submit(LandingPageCreatorFormValidator validator,
      AppLocalizations localization) {
    if (formKey.currentState!.validate() && user != null) {
      validationHasError = false;
      var promotionTemplateText = promotionTemplateTextController.text.trim();
      if (promotionTemplateText == "") {
        promotionTemplateText =
            localization.landingpage_create_promotion_template_default_text;
      }
      widget.onContinueTap(LandingPage(
          id: widget.id,
          name: nameTextController.text.trim(),
          description: descriptionTextController.text.trim(),
          promotionTemplate: promotionTemplateText,
          impressum: widget.landingPage?.impressum,
          privacyPolicy: widget.landingPage?.privacyPolicy,
          initialInformation: widget.landingPage?.initialInformation,
          termsAndConditions: widget.landingPage?.termsAndConditions,
          scriptTags: widget.landingPage?.scriptTags,
          contactEmailAddress: contactEmailAddressTextController.text.trim(),
          ownerID: user!.id));
    } else {
      validationHasError = true;
      Modular.get<LandingPageCubit>()
          .createLandingPage(null, Uint8List(0), false, "");
    }
  }

  void _insertTextAtCursor(String textToInsert) {
    int cursorIndex = promotionTemplateTextController.selection.baseOffset;

    if (cursorIndex == -1) {
      cursorIndex = 0;
      promotionTemplateTextController.selection =
          TextSelection.collapsed(offset: cursorIndex);
    }

    String newText = promotionTemplateTextController.text.replaceRange(
      cursorIndex,
      cursorIndex,
      textToInsert,
    );
    promotionTemplateTextController.text = newText;
    promotionTemplateTextController.selection =
        TextSelection.collapsed(offset: cursorIndex + textToInsert.length);
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

    return BlocConsumer<LandingPageCubit, LandingPageState>(
      bloc: landingPageCubit,
      listener: (context, state) {
        if (state is GetUserSuccessState) {
          user = state.user;
        }
      },
      builder: (context, state) {
        if (state is GetUserFailureState) {
          return ErrorView(
              title: localization.profile_page_request_failure_message,
              message: DatabaseFailureMapper.mapFailureMessage(
                  state.failure, localization),
              callback: () => {Modular.get<LandingPageCubit>().getUser()});
        } else {
          return CardContainer(
              child: LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            if (state is GetUserLoadingState) {
              return const LoadingIndicator();
            } else {
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
                                  controller: nameTextController,
                                  disabled: false,
                                  placeholder: localization.placeholder_title,
                                  onChanged: resetError,
                                  validator: validator.validateLandingPageName)
                            ]),
                        const SizedBox(height: textFieldSpacing),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FormTextfield(
                                  maxWidth: maxWidth,
                                  controller: descriptionTextController,
                                  disabled: false,
                                  placeholder:
                                      localization.placeholder_description,
                                  onChanged: resetError,
                                  validator: validator.validateLandingPageText,
                                  minLines: 2,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline)
                            ]),
                        const SizedBox(height: textFieldSpacing),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FormTextfield(
                                  maxWidth: maxWidth,
                                  controller: contactEmailAddressTextController,
                                  disabled: false,
                                  placeholder: "Kontakt E-Mail Adresse",
                                  onChanged: resetError,
                                  validator: validator
                                      .validateLandingPageContactEmailAddress,
                                  keyboardType: TextInputType.emailAddress)
                            ]),
                        const SizedBox(height: textFieldSpacing),
                        const SizedBox(height: textFieldSpacing * 2),
                        SelectableText(
                            localization
                                .landingpage_create_promotion_template_description,
                            style: themeData.textTheme.bodyMedium),
                        const SizedBox(height: textFieldSpacing),
                        if (responsiveValue.isDesktop) ...[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isEmojiPickerExpanded =
                                            !_isEmojiPickerExpanded;
                                      });
                                    },
                                    child: Tooltip(
                                      message: localization
                                          .open_emoji_picker_tooltip,
                                      child: Text("😃",
                                          style: themeData.textTheme.bodyLarge),
                                    )),
                                const Spacer(),
                                LandingPageCreatorPlaceholderPicker(
                                    width: 250,
                                    onSelected: (placeholder) {
                                      _insertTextAtCursor(placeholder);
                                    })
                              ]),
                          ExpandedSection(
                              expand: _isEmojiPickerExpanded,
                              child: Column(
                                children: [
                                  CustomEmojiPicker(
                                      controller:
                                          promotionTemplateTextController),
                                  const SizedBox(height: textFieldSpacing),
                                ],
                              )),
                        ],
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FormTextfield(
                                  maxWidth: maxWidth,
                                  controller: promotionTemplateTextController,
                                  disabled: false,
                                  placeholder: localization
                                      .landingpage_create_promotion_template_placeholder,
                                  onChanged: resetError,
                                  minLines: 4,
                                  maxLines: 10,
                                  keyboardType: TextInputType.multiline)
                            ]),
                        const SizedBox(height: textFieldSpacing * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PrimaryButton(
                                title:
                                    localization.landingpage_creation_continue,
                                disabled: buttonDisabled,
                                isLoading:
                                    state is CreateLandingPageLoadingState ||
                                        state is EditLandingPageLoadingState,
                                width: responsiveValue.isMobile
                                    ? maxWidth - textFieldSpacing
                                    : maxWidth / 2 - textFieldSpacing,
                                onTap: () {
                                  submit(validator, localization);
                                })
                          ],
                        ),
                      ]));
            }
          }));
        }
      },
    );
  }
}
