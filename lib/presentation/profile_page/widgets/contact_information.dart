import 'package:finanzbegleiter/application/profile/profile_bloc/profile_bloc.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/auth_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ContactInformation extends StatefulWidget {
  final CustomUser user;

  const ContactInformation({required this.user, super.key});
  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final streetTextController = TextEditingController();
  final postcodeTextController = TextEditingController();
  final placeTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    const double textFieldSpacing = 20;

    bool showError = false;
    String errorMessage = "";
    bool validationHasError = false;

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailureState) {
            errorMessage =
                DatabaseFailureMapper.mapFailureMessage(state.failure);
            showError = true;
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
                                validator: validator.validatePostcode,
                                decoration: const InputDecoration(
                                    labelText: "", hintText: "en"),
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
                          if (formKey.currentState!.validate()) {
                            validationHasError = false;
                            BlocProvider.of<ProfileBloc>(context).add(
                                UpdateProfileEvent(
                                    user: widget.user.copyWith(
                                        firstName: firstNameTextController.text,
                                        lastName: lastNameTextController.text,
                                        address: streetTextController.text,
                                        postCode: postcodeTextController.text,
                                        place: placeTextController.text)));
                          } else {
                            validationHasError = true;
                            BlocProvider.of<ProfileBloc>(context)
                                .add(UpdateProfileEvent(user: null));
                          }
                        })
                  ],
                ),
                if (state is ProfileLoadingState) ...[
                  const SizedBox(height: 80),
                  const LoadingIndicator()
                ],
                if (errorMessage != "" &&
                    showError &&
                    state is ProfileFailureState &&
                    !validationHasError) ...[
                  const SizedBox(height: 20),
                  AuthErrorView(message: errorMessage)
                ]
              ],
            ),
          );
        },
      );
    }));
  }
}
