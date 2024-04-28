import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
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
      }
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
    }
  }

  void generateRecommendation() {
    print("GENERATE");
    sendMessageViaWhatsApp();
  }

  void sendMessageViaWhatsApp() async {
    /*   String url = "https://api.whatsapp.com/send?text=iwanttotestit";
    if (await canLaunchUrl(Uri.parse(Uri.encodeFull(url)))) {
      await launchUrl(Uri.parse(Uri.encodeFull(url)));
    } else {
      throw "Could not launch";
    } */
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
                      Text(localization.recommendations_title,
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FormTextfield(
                                maxWidth: maxWidth,
                                controller: promoterTextController,
                                disabled: promoterTextFieldDisabled,
                                placeholder: localization
                                    .recommendations_form_promoter_placeholder,
                                onChanged: resetError,
                                validator: validator.validatePromotersName)
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FormTextfield(
                                maxWidth: maxWidth,
                                controller: serviceProviderTextController,
                                disabled: true,
                                placeholder: localization
                                    .recommendations_form_service_provider_placeholder,
                                onChanged: resetError,
                                validator: validator.validateRecommendorsName)
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FormTextfield(
                                maxWidth: maxWidth * 0.85,
                                controller: recommendorTextController,
                                disabled: false,
                                placeholder: localization
                                    .recommendations_form_recommendation_name_placeholder,
                                onChanged: resetError,
                                onFieldSubmitted: () {
                                  addRecommendor(validator);
                                  focusNode!.requestFocus();
                                },
                                focusNode: focusNode,
                                validator: validator.validateRecommendorsName),
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
                              title: localization
                                  .recommendations_form_generate_recommendation_button_title,
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
                    title: localization.recommendations_error_view_title,
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
