import 'package:finanzbegleiter/application/admin_registration_code/admin_registration_code_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegistrationCodeCreator extends StatefulWidget {
  const RegistrationCodeCreator({super.key});

  @override
  State<RegistrationCodeCreator> createState() =>
      _RegistrationCodeCreatorState();
}

class _RegistrationCodeCreatorState extends State<RegistrationCodeCreator> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final firstNameTextController = TextEditingController();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;

  @override
  void dispose() {
    emailTextController.dispose();
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
      Modular.get<AdminRegistrationCodeCubit>().sendAdminRegistrationCode(
          emailTextController.text.trim(),
          UniqueID().value,
          firstNameTextController.text.trim());
    } else {
      validationHasError = true;
      Modular.get<AdminRegistrationCodeCubit>()
          .sendAdminRegistrationCode("", "", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    final cubit = Modular.get<AdminRegistrationCodeCubit>();

    return CenteredConstrainedWrapper(
      child:
          BlocConsumer<AdminRegistrationCodeCubit, AdminRegistrationCodeState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is AdminRegistrationCodeSendFailure) {
            errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
            showError = true;
          } else if (state is AdminRegistrationCodeSendSuccessful) {
            resetError();
            setState(() {
              emailTextController.text = "";
              firstNameTextController.text = "";
            });
            CustomSnackBar.of(context).showCustomSnackBar(
                localization.admin_registration_code_creator_success_snackbar);
          }
        },
        builder: (context, state) {
          return ListView(shrinkWrap: true, children: [
            CardContainer(
                child: Column(children: [
              SelectableText(localization.admin_registration_code_creator_title,
                  style: themeData.textTheme.headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SelectableText(
                  localization.admin_registration_code_creator_description,
                  style: themeData.textTheme.bodyLarge),
              const SizedBox(height: 40),
              Form(
                  key: formKey,
                  autovalidateMode: (state
                          is AdminRegistrationCodeSendSuccessfulShowValidationState)
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(children: [
                    FormTextfield(
                        controller: emailTextController,
                        disabled: false,
                        placeholder: localization
                            .admin_registration_code_creator_email_placeholder,
                        onChanged: resetError,
                        onFieldSubmitted: submit,
                        validator: validator.validateEmail,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),
                    FormTextfield(
                        controller: firstNameTextController,
                        disabled: false,
                        placeholder: localization
                            .admin_registration_code_creator_firstname_placeholder,
                        onChanged: resetError,
                        onFieldSubmitted: submit,
                        validator: validator.validateFirstName,
                        keyboardType: TextInputType.text),
                    const SizedBox(height: 20),
                    PrimaryButton(
                        title: localization
                            .admin_registration_code_creator_send_code_button,
                        disabled: state is AdminRegistrationCodeSendLoading,
                        isLoading: state is AdminRegistrationCodeSendLoading,
                        onTap: () {
                          submit();
                        }),
                    if (errorMessage != "" &&
                        showError &&
                        (state is AdminRegistrationCodeSendFailure) &&
                        !validationHasError) ...[
                      const SizedBox(height: 20),
                      FormErrorView(message: errorMessage)
                    ]
                  ]))
            ]))
          ]);
        },
      ),
    );
  }
}
