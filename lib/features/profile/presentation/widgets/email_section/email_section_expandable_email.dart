// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class EmailSectionExpandableEmail extends StatelessWidget {
  final TextEditingController emailTextController;
  final double maxWidth;
  final bool buttonDisabled;
  final bool isLoading;
  final Function resetError;
  final Function submit;

  const EmailSectionExpandableEmail({
    super.key,
    required this.emailTextController,
    required this.maxWidth,
    required this.buttonDisabled,
    required this.isLoading,
    required this.resetError,
    required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SelectableText(localization.profile_page_email_section_description,
          style: responsiveValue.isMobile
              ? themeData.textTheme.bodySmall
              : themeData.textTheme.bodyMedium),
      const SizedBox(height: 16),
      FormTextfield(
          controller: emailTextController,
          disabled: false,
          placeholder: localization.login_email,
          onChanged: resetError,
          onFieldSubmitted: () => submit,
          validator: validator.validateEmail,
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: localization
                  .profile_page_email_section_change_email_button_title,
              width:
                  responsiveValue.isMobile ? maxWidth - 20 : maxWidth / 2 - 20,
              disabled: buttonDisabled,
              isLoading: isLoading,
              onTap: () {
                submit();
              })
        ],
      )
    ]);
  }
}
