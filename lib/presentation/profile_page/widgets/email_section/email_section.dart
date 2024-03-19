// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_desktop.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_expandable_email.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_expandable_password.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_mobile.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_verification_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

enum EmailSectionVisibleTextField { password, email, none }

class EmailSection extends StatefulWidget {
  final CustomUser user;
  final Function sendEmailVerificationCallback;

  const EmailSection(
      {Key? key,
      required this.user,
      required this.sendEmailVerificationCallback})
      : super(key: key);

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

  EmailSectionVisibleTextField visibleField = EmailSectionVisibleTextField.none;
  bool _isExpanded = false;

  bool isEmailVerified = false;
  User? currentUser;

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
          .updateEmail(emailTextController.text);
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
          isEmailVerified = state.isEmailVerified;
        } else if (state is ProfileEmailUpdateFailureState) {
          errorMessage =
              AuthFailureMapper.mapFailureMessage(state.failure, localization);
          showError = true;
        } else if (state is ProfileReauthenticateForEmailUpdateSuccessState) {
          visibleField = EmailSectionVisibleTextField.email;
        } else if (state is ProfileEmailUpdateSuccessState) {
          BlocProvider.of<ProfileCubit>(context).signOutUser();
        } else if (state is ProfileGetCurrentUserSuccessState) {
          currentUser = state.user;
        } else if (state is ProfileResendEmailVerificationSuccessState) {
          widget.sendEmailVerificationCallback();
        }
      }, builder: (context, state) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(localization.profile_page_email_section_title,
              style: themeData.textTheme.headlineLarge!
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (responsiveValue.largerThan(MOBILE)) ...[
            EmailSectionDesktop(
                email: currentUser?.email,
                isEmailVerified: isEmailVerified,
                editEmailPressed: editEmailPressed)
          ] else ...[
            EmailSectionMobile(
                email: currentUser?.email,
                isEmailVerified: isEmailVerified,
                editEmailPressed: editEmailPressed)
          ],
          if (!isEmailVerified) ...[
            const SizedBox(height: 16),
            EmailsectionVerificationLink(
                onTap: () => {
                      BlocProvider.of<ProfileCubit>(context)
                          .resendEmailVerification()
                    }),
          ],
          if (state is ProfileResendEmailVerificationLoadingState) ...[
            const SizedBox(height: 80),
            const LoadingIndicator()
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
                          resetError: resetError,
                          submit: submitPassword)
                    ] else if (visibleField ==
                        EmailSectionVisibleTextField.email) ...[
                      EmailSectionExpandableEmail(
                          emailTextController: emailTextController,
                          maxWidth: maxWidth,
                          resetError: resetError,
                          submit: submitEmail)
                    ],
                    if (state is ProfileEmailLoadingState) ...[
                      const SizedBox(height: 80),
                      const LoadingIndicator()
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
