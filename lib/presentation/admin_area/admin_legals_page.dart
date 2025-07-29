import 'package:finanzbegleiter/application/legals/admin_legals/admin_legals_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/legals.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminLegalsPage extends StatefulWidget {
  const AdminLegalsPage({super.key});

  @override
  State<AdminLegalsPage> createState() => _AdminLegalsPageState();
}

class _AdminLegalsPageState extends State<AdminLegalsPage> {
  final avvController = TextEditingController();
  final privacyPolicyController = TextEditingController();
  final termsAndConditionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validationHasError = false;
  bool showError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    Modular.get<AdminLegalsCubit>().getLegals();
  }

  @override
  void dispose() {
    avvController.dispose();
    privacyPolicyController.dispose();
    termsAndConditionController.dispose();
    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void _onSave() {
    if (formKey.currentState?.validate() ?? false) {
      validationHasError = false;
      Modular.get<AdminLegalsCubit>().saveLegals(Legals(
          avv: avvController.text.trim(),
          privacyPolicy: privacyPolicyController.text.trim(),
          termsAndCondition: termsAndConditionController.text.trim()));
    } else {
      validationHasError = true;
      Modular.get<AdminLegalsCubit>().saveLegals(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<AdminLegalsCubit>();

    return CenteredConstrainedWrapper(
      child: BlocConsumer<AdminLegalsCubit, AdminLegalsState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is AdminGetLegalsSuccessState) {
            showError = false;
            avvController.text = state.legals.avv ?? '';
            privacyPolicyController.text = state.legals.privacyPolicy ?? '';
            termsAndConditionController.text =
                state.legals.termsAndCondition ?? '';
          } else if (state is AdminGetLegalsFailureState) {
            errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
            showError = true;
            avvController.clear();
            privacyPolicyController.clear();
            termsAndConditionController.clear();
          } else if (state is AdminSaveLegalsSuccessState) {
            showError = false;
            CustomSnackBar.of(context).showCustomSnackBar(
                "Daten für Rechtliches erfolgreich gespeichert!");
          }
        },
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            children: [
              CardContainer(
                maxWidth: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      "Rechtliches",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    if (state is AdminGetLegalsLoadingState)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(64.0),
                          child: LoadingIndicator(),
                        ),
                      )
                    else
                      Form(
                        key: formKey,
                        autovalidateMode:
                            (state is AdminLegalsShowValidationState)
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Auftragsverarbeitungsvertrag",
                              style: themeData.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FormTextfield(
                              controller: avvController,
                              maxWidth: double.infinity,
                              placeholder: "AVV eingeben...",
                              maxLines: 15,
                              minLines: 15,
                              disabled: false,
                              onChanged: resetError,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Datenschutzerklärung",
                              style: themeData.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FormTextfield(
                              controller: privacyPolicyController,
                              maxWidth: double.infinity,
                              placeholder: "Datenschutzerklärung eingeben...",
                              maxLines: 15,
                              minLines: 15,
                              disabled: false,
                              onChanged: resetError,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Allgemeine Geschäftsbedingungen",
                              style: themeData.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FormTextfield(
                              controller: termsAndConditionController,
                              maxWidth: double.infinity,
                              placeholder: "AGBs eingeben...",
                              maxLines: 15,
                              minLines: 15,
                              disabled: false,
                              onChanged: resetError,
                            ),
                            const SizedBox(height: 32),
                            PrimaryButton(
                              title: "Speichern",
                              onTap: _onSave,
                              isLoading: state is AdminSaveLegalsLoadingState,
                              width: 200,
                            ),
                            if (errorMessage != "" &&
                                showError &&
                                (state is AdminSaveLegalsFailureState) &&
                                !validationHasError) ...[
                              const SizedBox(height: 20),
                              FormErrorView(message: errorMessage)
                            ]
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
