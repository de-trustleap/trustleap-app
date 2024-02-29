// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/profile/profile_bloc/profile_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_expandable_email.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_expandable_password.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_verification_link.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_verification_badge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

enum VisibleTextField { password, email, none }

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

  VisibleTextField visibleField = VisibleTextField.none;
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

  void submitPassword() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileBloc>(context).add(
          ReauthenticateWithPasswordInitiated(
              password: passwordTextController.text));
    }
  }

  void submitEmail() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileBloc>(context)
          .add(UpdateEmailEvent(email: emailTextController.text));
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

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
        if (state is ProfileEmailVerifySuccessState) {
          isEmailVerified = state.isEmailVerified;
        } else if (state is ProfileEmailUpdateFailureState) {
          errorMessage = AuthFailureMapper.mapFailureMessage(state.failure);
          showError = true;
        } else if (state is ProfileReauthenticateSuccessState) {
          visibleField = VisibleTextField.email;
        } else if (state is ProfileEmailUpdateSuccessState) {
          BlocProvider.of<ProfileBloc>(context).add(SignoutUserEvent());
        } else if (state is ProfileGetCurrentUserSuccessState) {
          currentUser = state.user;
        } else if (state is ProfileResendEmailVerificationSuccessState) {
          widget.sendEmailVerificationCallback();
        }
      }, builder: (context, state) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("E-Mail Einstellungen",
              style: themeData.textTheme.headlineLarge!
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(50),
                1: FlexColumnWidth(25),
                2: FlexColumnWidth(25)
              },
              children: [
                TableRow(children: [
                  Text("E-Mail",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Status",
                        style: themeData.textTheme.headlineLarge!
                            .copyWith(fontSize: 16)),
                  ),
                  const SizedBox(width: 8)
                ]),
                const TableRow(children: [
                  SizedBox(height: 8),
                  SizedBox(height: 8),
                  SizedBox(height: 8)
                ]),
                TableRow(children: [
                  Text(currentUser?.email ?? "",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 16)),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: EmailVerificationBadge(
                          state: isEmailVerified
                              ? EmailVerificationState.verified
                              : EmailVerificationState.unverified)),
                  IconButton(
                      onPressed: () => {
                            setState(() {
                              _toogleExpand();
                              _clearFields();
                              if (visibleField == VisibleTextField.password ||
                                  visibleField == VisibleTextField.email) {
                                visibleField = VisibleTextField.none;
                              } else {
                                visibleField = VisibleTextField.password;
                              }
                            })
                          },
                      icon: Icon(Icons.edit,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 22)),
                ])
              ]),
          if (!isEmailVerified) ...[
            const SizedBox(height: 16),
            EmailsectionVerificationLink(
                onTap: () => {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(ResendEmailVerificationEvent())
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
                    if (visibleField == VisibleTextField.password) ...[
                      EmailSectionExpandablePassword(
                          passwordTextController: passwordTextController,
                          maxWidth: maxWidth,
                          resetError: resetError,
                          submit: submitPassword)
                    ] else if (visibleField == VisibleTextField.email) ...[
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
