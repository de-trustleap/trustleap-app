// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorForm extends StatefulWidget {
  final UniqueID id;
  final LandingPage? landingPage;
  final Function(LandingPage) onSaveTap;
  final Function(LandingPage) onEditTapped;
  const LandingPageCreatorForm(
      {super.key,
      required this.id,
      this.landingPage,
      required this.onSaveTap,
      required this.onEditTapped});

  @override
  State<LandingPageCreatorForm> createState() => _LandingPageCreatorFormState();
}

class _LandingPageCreatorFormState extends State<LandingPageCreatorForm> {
  final nameTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomUser? user;

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LandingPageCubit>(context).getUser();

    if (widget.landingPage != null) {
      nameTextController.text = widget.landingPage?.name ?? "";
      descriptionTextController.text = widget.landingPage?.description ?? "";
    }
  }

  @override
  void dispose() {
    nameTextController.dispose();
    descriptionTextController.dispose();

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

  void submit(LandingPageCreatorFormValidator validator) {
    if (formKey.currentState!.validate() && user != null) {
      validationHasError = false;
      if (widget.landingPage == null) {
        widget.onSaveTap(LandingPage(
            id: widget.id,
            name: nameTextController.text.trim(),
            description: descriptionTextController.text.trim(),
            ownerID: user!.id));
      } else {
        widget.onEditTapped(widget.landingPage!.copyWith(
            name: nameTextController.text.trim(),
            description: descriptionTextController.text.trim()));
      }
    } else {
      validationHasError = true;
      BlocProvider.of<LandingPageCubit>(context)
          .createLandingPage(null, Uint8List(0), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator =
        LandingPageCreatorFormValidator(localization: localization);
    const double textFieldSpacing = 20;

    return BlocConsumer<LandingPageCubit, LandingPageState>(
      listener: (context, state) {
        if (state is GetUserSuccessState) {
          user = state.user;
        } else if (state is CreateLandingPageFailureState) {
          setState(() {
            showError = true;
            errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
          });
          setButtonToDisabled(false);
        } else if (state is EditLandingPageFailureState) {
          setState(() {
            showError = true;
            errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
          });
          setButtonToDisabled(false);
        } else if (state is CreatedLandingPageSuccessState ||
            state is EditLandingPageSuccessState) {
          setButtonToDisabled(false);
        } else if (state is CreateLandingPageLoadingState ||
            state is EditLandingPageLoadingState) {
          setButtonToDisabled(true);
        }
      },
      builder: (context, state) {
        if (state is GetUserFailureState) {
          return ErrorView(
              title: localization.profile_page_request_failure_message,
              message: DatabaseFailureMapper.mapFailureMessage(
                  state.failure, localization),
              callback: () =>
                  {BlocProvider.of<LandingPageCubit>(context).getUser()});
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
                                  placeholder: localization.placeholder_text,
                                  onChanged: resetError,
                                  validator: validator.validateLandingPageText,
                                  minLines: 2,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline)
                            ]),
                        const SizedBox(height: textFieldSpacing * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PrimaryButton(
                                title: widget.landingPage == null
                                    ? localization
                                        .landingpage_create_buttontitle
                                    : localization.changes_save_button_title,
                                disabled: buttonDisabled,
                                isLoading:
                                    state is CreateLandingPageLoadingState ||
                                        state is EditLandingPageLoadingState,
                                width: responsiveValue.isMobile
                                    ? maxWidth - textFieldSpacing
                                    : maxWidth / 2 - textFieldSpacing,
                                onTap: () {
                                  submit(validator);
                                })
                          ],
                        ),
                        if (errorMessage != "" &&
                            showError &&
                            (state is CreateLandingPageFailureState ||
                                state is EditLandingPageFailureState) &&
                            !validationHasError) ...[
                          const SizedBox(height: 20),
                          FormErrorView(message: errorMessage)
                        ]
                      ]));
            }
          }));
        }
      },
    );
  }
}
