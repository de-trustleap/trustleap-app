import 'package:finanzbegleiter/application/profile/profile_bloc/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ContactSection extends StatefulWidget {
  final CustomUser user;
  final Function changesSaved;

  const ContactSection(
      {required this.user, required this.changesSaved, super.key});
  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final streetTextController = TextEditingController();
  final postcodeTextController = TextEditingController();
  final placeTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        firstNameTextController.text = widget.user.firstName ?? "";
        lastNameTextController.text = widget.user.lastName ?? "";
        streetTextController.text = widget.user.address ?? "";
        postcodeTextController.text = widget.user.postCode ?? "";
        placeTextController.text = widget.user.place ?? "";
      });
    });
  }

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    streetTextController.dispose();
    postcodeTextController.dispose();
    placeTextController.dispose();

    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileCubit>(context).updateProfile(widget.user.copyWith(
          firstName: firstNameTextController.text,
          lastName: lastNameTextController.text,
          address: streetTextController.text,
          postCode: postcodeTextController.text,
          place: placeTextController.text));
    } else {
      validationHasError = true;
      BlocProvider.of<ProfileCubit>(context).updateProfile(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    const double textFieldSpacing = 20;

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateContactInformationFailureState) {
            errorMessage =
                DatabaseFailureMapper.mapFailureMessage(state.failure);
            showError = true;
          } else if (state is ProfileUpdateContactInformationSuccessState) {
            widget.changesSaved();
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            autovalidateMode: (state is ProfileShowValidationState)
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Kontaktinformationen",
                    style: themeData.textTheme.headlineLarge!
                        .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ResponsiveRowColumn(
                    columnMainAxisSize: MainAxisSize.min,
                    layout: responsiveValue.isMobile
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    children: [
                      ResponsiveRowColumnItem(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text("Vorname",
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(fontSize: 16)),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: responsiveValue.isMobile
                                  ? maxWidth
                                  : maxWidth / 2,
                              child: TextFormField(
                                controller: firstNameTextController,
                                onFieldSubmitted: (_) => submit(),
                                onChanged: (_) {
                                  resetError();
                                },
                                validator: validator.validateFirstName,
                                decoration:
                                    const InputDecoration(labelText: ""),
                              ),
                            ),
                          ])),
                      const ResponsiveRowColumnItem(
                          child: SizedBox(
                              height: textFieldSpacing,
                              width: textFieldSpacing)),
                      ResponsiveRowColumnItem(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text("Nachname",
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(fontSize: 16)),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: responsiveValue.isMobile
                                  ? maxWidth
                                  : maxWidth / 2 - textFieldSpacing,
                              child: TextFormField(
                                controller: lastNameTextController,
                                onFieldSubmitted: (_) => submit(),
                                onChanged: (_) {
                                  resetError();
                                },
                                validator: validator.validateLastName,
                                decoration:
                                    const InputDecoration(labelText: ""),
                              ),
                            ),
                          ]))
                    ]),
                const SizedBox(height: textFieldSpacing),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Straße und Hausnummer",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: maxWidth,
                    child: TextFormField(
                      controller: streetTextController,
                      onFieldSubmitted: (_) => submit(),
                      onChanged: (_) {
                        resetError();
                      },
                      decoration: const InputDecoration(labelText: ""),
                    ),
                  ),
                ]),
                const SizedBox(height: textFieldSpacing),
                ResponsiveRowColumn(
                    columnMainAxisSize: MainAxisSize.min,
                    layout: responsiveValue.isMobile
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    children: [
                      ResponsiveRowColumnItem(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text("PLZ",
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(fontSize: 16)),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: responsiveValue.isMobile
                                  ? maxWidth
                                  : maxWidth / 2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: postcodeTextController,
                                onFieldSubmitted: (_) => submit(),
                                onChanged: (_) {
                                  resetError();
                                },
                                validator: validator.validatePostcode,
                                decoration:
                                    const InputDecoration(labelText: ""),
                              ),
                            ),
                          ])),
                      const ResponsiveRowColumnItem(
                          child: SizedBox(
                              height: textFieldSpacing,
                              width: textFieldSpacing)),
                      ResponsiveRowColumnItem(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text("Ort",
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(fontSize: 16)),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: responsiveValue.isMobile
                                  ? maxWidth
                                  : maxWidth / 2 - textFieldSpacing,
                              child: TextFormField(
                                controller: placeTextController,
                                onFieldSubmitted: (_) => submit(),
                                onChanged: (_) {
                                  resetError();
                                },
                                decoration:
                                    const InputDecoration(labelText: ""),
                              ),
                            ),
                          ]))
                    ]),
                const SizedBox(height: textFieldSpacing * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PrimaryButton(
                        title: "Änderungen speichern",
                        width: maxWidth / 2 - textFieldSpacing,
                        onTap: () {
                          submit();
                        })
                  ],
                ),
                if (state is ProfileUpdateContactInformationLoadingState) ...[
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
            ),
          );
        },
      );
    }));
  }
}
