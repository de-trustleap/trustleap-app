import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_reason_picker.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendors_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendorItem extends Equatable {
  final String name;
  final String reason;

  const RecommendorItem({required this.name, required this.reason});

  @override
  List<Object?> get props => [name, reason];
}

class RecommendationsForm extends StatefulWidget {
  const RecommendationsForm({super.key});

  @override
  State<RecommendationsForm> createState() => _RecommendationsFormState();
}

class _RecommendationsFormState extends State<RecommendationsForm> {
  final promoterTextController = TextEditingController();
  final recommendorTextController = TextEditingController();
  final serviceProviderTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RecommendationReason? selectedReason;
  FocusNode? focusNode;
  CustomUser? currentUser;
  CustomUser? parentUser;

  List<RecommendorItem> recommendors = [];

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  String? reasonValid;
  bool promoterTextFieldDisabled = false;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    promoterTextController.dispose();
    recommendorTextController.dispose();
    serviceProviderTextController.dispose();
    focusNode!.dispose();

    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void addRecommendor(RecommendorsValidator validator) {
    print("SUBMIT");
    if (formKey.currentState!.validate() &&
        validator.validateReason(selectedReason) == null) {
      setState(() {
        validationHasError = false;
        reasonValid = null;
        recommendors.add(RecommendorItem(
            name: recommendorTextController.text.trim(),
            reason: selectedReason!.value));
        recommendorTextController.clear();
      });
    } else {
      setState(() {
        validationHasError = true;
        reasonValid = validator.validateReason(selectedReason);
      });
    }
  }

  void setUser(CustomUser user) {
    if (user.firstName != null && user.lastName != null) {
      if (user.role == Role.promoter) {
        currentUser = user;
        setState(() {
          promoterTextFieldDisabled = true;
          promoterTextController.text =
              "${currentUser!.firstName} ${currentUser!.lastName}";
        });
      } else {
        parentUser = user;
        setState(() {
          serviceProviderTextController.text =
              "${parentUser!.firstName} ${parentUser!.lastName}";
        });
      } // TODO: Textfield muss readyOnly sein wenn es einen user gibt.
    }
  }

  void setParentUser(CustomUser user) {
    parentUser = user;
    if (parentUser != null &&
        parentUser!.firstName != null &&
        parentUser!.lastName != null) {
      setState(() {
        serviceProviderTextController.text =
            "${parentUser!.firstName} ${parentUser!.lastName}";
      });
    } // TODO: Textfield muss readyOnly sein wenn es einen parent user gibt.
  }

  void generateRecommendation() {
    print("GENERATE");
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator = RecommendorsValidator(localization: localization);
    const double textFieldSpacing = 20;

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<RecommendationsCubit, RecommendationsState>(
        listener: (context, state) {
          if (state is RecommendationGetCurrentUserSuccessState) {
            setUser(state.user);
            if (state.user.role == Role.promoter &&
                state.user.parentUserID != null) {
              print("PROMOTER");
              BlocProvider.of<RecommendationsCubit>(context)
                  .getParentUser(state.user.parentUserID!);
            }
          } else if (state is RecommendationGetParentUserSuccessState) {
            setParentUser(state.user);
          }
        },
        builder: (context, state) {
          if (state is RecommendationGetCurrentUserSuccessState ||
              state is RecommendationGetParentUserSuccessState) {
            return Form(
                key: formKey,
                autovalidateMode: validationHasError
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Empfehlungen generieren",
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: maxWidth,
                              child: TextFormField(
                                controller: promoterTextController,
                                onChanged: (_) {
                                  resetError();
                                },
                                readOnly:
                                    promoterTextFieldDisabled ? true : false,
                                validator: validator.validatePromotersName,
                                style: responsiveValue.isMobile
                                    ? themeData.textTheme.bodySmall
                                    : themeData.textTheme.bodyMedium,
                                decoration: InputDecoration(
                                    labelText: "Promoter",
                                    hoverColor: Colors.transparent,
                                    filled: promoterTextFieldDisabled
                                        ? true
                                        : false,
                                    fillColor:
                                        themeData.colorScheme.background),
                              ),
                            ),
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: maxWidth,
                              child: TextFormField(
                                  controller: serviceProviderTextController,
                                  onChanged: (_) {
                                    resetError();
                                  },
                                  readOnly: true,
                                  validator: validator.validateRecommendorsName,
                                  style: responsiveValue.isMobile
                                      ? themeData.textTheme.bodySmall
                                      : themeData.textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                      labelText: "Dienstleister",
                                      hoverColor: Colors.transparent,
                                      filled: true,
                                      fillColor:
                                          themeData.colorScheme.background)),
                            ),
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: maxWidth * 0.85,
                              child: TextFormField(
                                controller: recommendorTextController,
                                onFieldSubmitted: (_) {
                                  addRecommendor(validator);
                                  focusNode!.requestFocus();
                                },
                                onChanged: (_) {
                                  resetError();
                                },
                                focusNode: focusNode,
                                validator: validator.validateRecommendorsName,
                                style: responsiveValue.isMobile
                                    ? themeData.textTheme.bodySmall
                                    : themeData.textTheme.bodyMedium,
                                decoration: const InputDecoration(
                                    labelText: "Empfehlungsname"),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () => addRecommendor(validator),
                                icon: const Icon(Icons.add_circle),
                                iconSize: 48,
                                color: themeData.colorScheme.secondary)
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (var recommendor in recommendors)
                          Chip(
                            label: Text(
                                "${recommendor.name}\n${recommendor.reason}",
                                maxLines: 2),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                recommendors.remove(recommendor);
                              });
                            },
                          )
                      ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RecommendationReaseonPicker(
                                width: maxWidth,
                                validate: reasonValid,
                                initialValue: selectedReason,
                                onSelected: (reason) {
                                  setState(() {
                                    reasonValid =
                                        validator.validateReason(reason);
                                    selectedReason = reason;
                                  });
                                  resetError();
                                })
                          ]),
                      const SizedBox(height: textFieldSpacing * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PrimaryButton(
                              title: "Empfehlung generieren",
                              width: responsiveValue.isMobile
                                  ? maxWidth - textFieldSpacing
                                  : maxWidth / 2 - textFieldSpacing,
                              onTap: () {
                                generateRecommendation();
                              })
                        ],
                      ),
                    ]));
          } else if (state is RecommendationGetUserFailureState) {
            return CenteredConstrainedWrapper(
                child: ErrorView(
                    title: "Beim Abrufen der Daten ist ein Fehler aufgetreten",
                    message: DatabaseFailureMapper.mapFailureMessage(
                        state.failure, localization),
                    callback: () => {
                          BlocProvider.of<RecommendationsCubit>(context)
                              .getUser()
                        }));
          } else {
            return CenteredConstrainedWrapper(
                child: CircularProgressIndicator(
                    color: themeData.colorScheme.secondary));
          }
        },
      );
    }));
  }
}
