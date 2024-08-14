// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/gender_picker.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration/register_promoter_no_landingpage_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCheckboxItem {
  LandingPage landingPage;
  bool isSelected;
  LandingPageCheckboxItem({
    required this.landingPage,
    required this.isSelected,
  });
}

class RegisterPromotersForm extends StatefulWidget {
  final Function changesSaved;

  const RegisterPromotersForm({
    super.key,
    required this.changesSaved,
  });

  @override
  State<RegisterPromotersForm> createState() => _RegisterPromotersFormState();
}

class _RegisterPromotersFormState extends State<RegisterPromotersForm> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final birthDateTextController = TextEditingController();
  final emailTextController = TextEditingController();

  Gender? selectedGender;
  CustomUser? currentUser;
  List<LandingPageCheckboxItem> landingPageItems = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  String? genderValid;
  bool buttonDisabled = false;

  @override
  void initState() {
    BlocProvider.of<PromoterCubit>(context).getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    birthDateTextController.dispose();
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

  void submit(AuthValidator validator) {
    if (formKey.currentState!.validate() &&
        validator.validateGender(selectedGender) == null) {
      validationHasError = false;
      setState(() {
        genderValid = null;
      });
      if (currentUser != null) {
        BlocProvider.of<PromoterCubit>(context).registerPromoter(
            UnregisteredPromoter(
                id: UniqueID(),
                gender: selectedGender,
                firstName: firstNameTextController.text.trim(),
                lastName: lastNameTextController.text.trim(),
                birthDate: birthDateTextController.text.trim(),
                email: emailTextController.text.trim(),
                landingPageIDs: getSelectedLandingPagesIDs(),
                defaultLandingPageID: UniqueID.fromUniqueString(
                    currentUser?.defaultLandingPageID ?? ""),
                parentUserID:
                    UniqueID.fromUniqueString(currentUser?.id.value ?? ""),
                companyID:
                    UniqueID.fromUniqueString(currentUser?.companyID ?? ""),
                code: UniqueID()));
      }
    } else {
      validationHasError = true;
      setState(() {
        genderValid = validator.validateGender(selectedGender);
      });
      BlocProvider.of<PromoterCubit>(context).registerPromoter(null);
    }
  }

  List<String> getSelectedLandingPagesIDs() {
    return landingPageItems
        .map((e) {
          if (e.isSelected) {
            return e.landingPage.id.value;
          }
        })
        .whereType<String>()
        .toList();
  }

  List<Widget> createCheckboxes() {
    List<Widget> checkboxes = [];
    landingPageItems.asMap().forEach((index, _) {
      checkboxes.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Checkbox(
            value: landingPageItems[index].isSelected,
            onChanged: ((value) {
              if (value != null) {
                setState(() {
                  landingPageItems[index].isSelected = value;
                });
              }
            })),
        const SizedBox(width: 8),
        Text(landingPageItems[index].landingPage.name ?? "")
      ]));
    });
    return checkboxes;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    const double textFieldSpacing = 20;
    return BlocConsumer<PromoterCubit, PromoterState>(
      listener: (context, state) {
        if (state is PromoterRegisterFailureState) {
          errorMessage = DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization);
          showError = true;
          setButtonToDisabled(false);
        } else if (state is PromoterAlreadyExistsFailureState) {
          errorMessage = localization.register_promoter_email_already_in_use;
          showError = true;
          setButtonToDisabled(false);
        } else if (state is PromoterRegisteredSuccessState) {
          widget.changesSaved();
          setButtonToDisabled(false);
        } else if (state is PromoterGetCurrentUserSuccessState) {
          currentUser = state.user;
          BlocProvider.of<PromoterCubit>(context)
              .getPromotingLandingPages(currentUser?.landingPageIDs ?? []);
        } else if (state is PromoterRegisterLoadingState) {
          setButtonToDisabled(true);
        } else if (state is PromoterGetLandingPagesSuccessState) {
          setState(() {
            for (var landingPage in state.landingPages) {
              landingPageItems.add(LandingPageCheckboxItem(
                  landingPage: landingPage, isSelected: false));
            }
          });
        }
      },
      builder: (context, state) {
        return CardContainer(
            child: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          if (state is PromoterLoadingState) {
            return const LoadingIndicator();
          } else if (state is PromoterGetCurrentUserFailureState) {
            return ErrorView(
                title: localization.landingpage_overview_error_view_title,
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () =>
                    {BlocProvider.of<PromoterCubit>(context).getCurrentUser()});
          } else if (state is PromoterGetLandingPagesFailureState) {
            return ErrorView(
                title: localization.landingpage_overview_error_view_title,
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () => {
                      BlocProvider.of<PromoterCubit>(context)
                          .getPromotingLandingPages(
                              currentUser?.landingPageIDs ?? [])
                    });
          } else if (state is PromoterNoLandingPagesState) {
            return const RegisterPromoterNoLandingPageView();
          } else {
            return Form(
                key: formKey,
                autovalidateMode: (state is PromoterShowValidationState)
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localization.register_promoter_title,
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: textFieldSpacing + 4),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GenderPicker(
                                width: maxWidth,
                                validate: genderValid,
                                onSelected: (gender) {
                                  setState(() {
                                    genderValid =
                                        validator.validateGender(gender);
                                    selectedGender = gender;
                                  });
                                  resetError();
                                })
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      ResponsiveRowColumn(
                          columnMainAxisSize: MainAxisSize.min,
                          layout: responsiveValue.isMobile
                              ? ResponsiveRowColumnType.COLUMN
                              : ResponsiveRowColumnType.ROW,
                          children: [
                            ResponsiveRowColumnItem(
                                child: FormTextfield(
                                    maxWidth: responsiveValue.isMobile
                                        ? maxWidth
                                        : maxWidth / 2,
                                    controller: firstNameTextController,
                                    disabled: false,
                                    placeholder: localization
                                        .register_promoter_first_name,
                                    onChanged: resetError,
                                    onFieldSubmitted: (_) => submit(validator),
                                    validator: validator.validateFirstName)),
                            const ResponsiveRowColumnItem(
                                child: SizedBox(
                                    height: textFieldSpacing,
                                    width: textFieldSpacing)),
                            ResponsiveRowColumnItem(
                                child: FormTextfield(
                                    maxWidth: responsiveValue.isMobile
                                        ? maxWidth
                                        : maxWidth / 2 - textFieldSpacing,
                                    controller: lastNameTextController,
                                    disabled: false,
                                    placeholder: localization
                                        .register_promoter_last_name,
                                    onChanged: resetError,
                                    onFieldSubmitted: (_) => submit(validator),
                                    validator: validator.validateLastName))
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FormTextfield(
                                maxWidth: maxWidth,
                                controller: birthDateTextController,
                                disabled: false,
                                placeholder:
                                    localization.register_promoter_birthdate,
                                onChanged: resetError,
                                onFieldSubmitted: (_) => submit(validator),
                                validator: validator.validateLastName,
                                keyboardType: TextInputType.datetime,
                                prefixIcon: Icons.calendar_today_rounded,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now());
                                  if (pickedDate != null) {
                                    setState(() {
                                      birthDateTextController.text =
                                          DateFormat("dd.MM.yyyy")
                                              .format(pickedDate);
                                    });
                                  }
                                })
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FormTextfield(
                                maxWidth: maxWidth,
                                controller: emailTextController,
                                disabled: false,
                                placeholder:
                                    localization.register_promoter_email,
                                onChanged: resetError,
                                onFieldSubmitted: (_) => submit(validator),
                                validator: validator.validateEmail,
                                keyboardType: TextInputType.emailAddress)
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Column(children: createCheckboxes()),
                      const SizedBox(height: textFieldSpacing * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PrimaryButton(
                              title: localization
                                  .register_promoter_register_button,
                              width: responsiveValue.isMobile
                                  ? maxWidth - textFieldSpacing
                                  : maxWidth / 2 - textFieldSpacing,
                              disabled: buttonDisabled,
                              onTap: () {
                                submit(validator);
                              })
                        ],
                      ),
                      if (state is PromoterRegisterLoadingState) ...[
                        const SizedBox(height: 80),
                        const LoadingIndicator()
                      ] else if (state is PromoterLandingPagesMissingState) ...[
                        const SizedBox(height: 20),
                        const FormErrorView(
                            message:
                                "Dem Promoter wurde noch keine Landingpage zugewiesen")
                      ] else if (state is PromoterCompanyMissingState) ...[
                        const SizedBox(height: 20),
                        const FormErrorView(
                            message:
                                "Du kannst keinen Promoter registrieren, da du keinem Unternehmen zugehörig bist")
                      ] else if (errorMessage != "" &&
                          showError &&
                          (state is PromoterRegisterFailureState ||
                              state is PromoterAlreadyExistsFailureState) &&
                          !validationHasError) ...[
                        const SizedBox(height: 20),
                        FormErrorView(message: errorMessage)
                      ]
                    ]));
          }
        }));
      },
    );
  }
}
