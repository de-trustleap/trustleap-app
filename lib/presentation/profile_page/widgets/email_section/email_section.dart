// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_desktop.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_expandable_email.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_expandable_password.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum EmailSectionVisibleTextField { password, email, none }

class EmailSection extends StatefulWidget {
  final CustomUser user;
  final Function sendEmailVerificationCallback;

  const EmailSection(
      {super.key,
      required this.user,
      required this.sendEmailVerificationCallback});

  @override
  State<EmailSection> createState() => _EmailSectionState();
}

class _EmailSectionState extends State<EmailSection> {
  final passwordTextController = TextEditingController();
  final emailTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;

  EmailSectionVisibleTextField visibleField = EmailSectionVisibleTextField.none;
  bool _isExpanded = false;

  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).verifyEmail();
  }

  @override
  void dispose() {
    passwordTextController.dispose();
    emailTextController.dispose();

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

  void _toogleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      resetError();
    });
  }

  void editEmailPressed() {
    setState(() {
      _toogleExpand();
      _clearFields();
      if (visibleField == EmailSectionVisibleTextField.password ||
          visibleField == EmailSectionVisibleTextField.email) {
        visibleField = EmailSectionVisibleTextField.none;
      } else {
        visibleField = EmailSectionVisibleTextField.password;
      }
    });
  }

  void submitPassword() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileCubit>(context)
          .reauthenticateWithPasswordForEmailUpdate(
              passwordTextController.text);
    }
  }

  void submitEmail() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileCubit>(context)
          .updateEmail(emailTextController.text.trim());
    }
  }

  void _clearFields() {
    passwordTextController.clear();
    emailTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
        if (state is ProfileEmailVerifySuccessState) {
          setState(() {
            isEmailVerified = state.isEmailVerified;
          });
        } else if (state is ProfileEmailUpdateFailureState) {
          errorMessage =
              AuthFailureMapper.mapFailureMessage(state.failure, localization);
          showError = true;
          setButtonToDisabled(false);
        } else if (state is ProfileReauthenticateForEmailUpdateSuccessState) {
          visibleField = EmailSectionVisibleTextField.email;
          setButtonToDisabled(false);
        } else if (state is ProfileEmailUpdateSuccessState) {
          BlocProvider.of<AuthCubit>(context).signOut();
          setButtonToDisabled(false);
        } else if (state is ProfileResendEmailVerificationSuccessState) {
          widget.sendEmailVerificationCallback();
        } else if (state is ProfileEmailLoadingState) {
          setButtonToDisabled(true);
        }
      }, builder: (context, state) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SelectableText(localization.profile_page_email_section_title,
              style: themeData.textTheme.headlineLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (responsiveValue.largerThan(MOBILE)) ...[
            EmailSectionDesktop(
                email: widget.user.email,
                isEmailVerified: isEmailVerified,
                editEmailPressed: editEmailPressed)
          ] else ...[
            EmailSectionMobile(
                email: widget.user.email,
                isEmailVerified: isEmailVerified,
                editEmailPressed: editEmailPressed)
          ],
          if (!isEmailVerified) ...[
            const SizedBox(height: 16),
            ClickableLink(
                title: localization
                    .profile_page_email_section_resend_verify_email_button_title,
                onTap: () => {
                      BlocProvider.of<ProfileCubit>(context)
                          .resendEmailVerification()
                    }),
          ],
          if (state is ProfileResendEmailVerificationLoadingState) ...[
            const SizedBox(height: 80),
            const LoadingIndicator()
          ],
          if (state is ProfileResendEmailVerificationFailureState) ...[
            FormErrorView(
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization))
          ],
          const SizedBox(height: 32),
          ExpandedSection(
            expand: _isExpanded,
            child: Form(
                key: formKey,
                autovalidateMode: (state is ProfileShowValidationState)
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (visibleField ==
                        EmailSectionVisibleTextField.password) ...[
                      EmailSectionExpandablePassword(
                          passwordTextController: passwordTextController,
                          maxWidth: maxWidth,
                          buttonDisabled: buttonDisabled,
                          isLoading: state is ProfileEmailLoadingState,
                          resetError: resetError,
                          submit: submitPassword)
                    ] else if (visibleField ==
                        EmailSectionVisibleTextField.email) ...[
                      EmailSectionExpandableEmail(
                          emailTextController: emailTextController,
                          maxWidth: maxWidth,
                          buttonDisabled: buttonDisabled,
                          isLoading: state is ProfileEmailLoadingState,
                          resetError: resetError,
                          submit: submitEmail)
                    ],
                    if (errorMessage != "" &&
                        showError &&
                        state is ProfileEmailUpdateFailureState &&
                        !validationHasError) ...[
                      const SizedBox(height: 20),
                      FormErrorView(message: errorMessage)
                    ]
                  ],
                )),
          ),
        ]);
      });
    }));
  }
}
