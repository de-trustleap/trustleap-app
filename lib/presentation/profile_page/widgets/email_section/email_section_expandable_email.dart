// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class EmailSectionExpandableEmail extends StatelessWidget {
  final TextEditingController emailTextController;
  final double maxWidth;
  final Function resetError;
  final Function submit;

  const EmailSectionExpandableEmail({
    Key? key,
    required this.emailTextController,
    required this.maxWidth,
    required this.resetError,
    required this.submit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    final themeData = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          "Geben Sie jetzt ihre neue E-Mail Adresse an und bestätigen Sie. An die neue E-Mail Adresse wird anschließend ein Bestätigungslink gesendet. Durch diesen Link können Sie Ihre neue E-Mail Adresse verifizieren und sich erneut anmelden.",
          style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
      const SizedBox(height: 16),
      TextFormField(
        controller: emailTextController,
        keyboardType: TextInputType.emailAddress,
        onChanged: (_) {
          resetError();
        },
        onFieldSubmitted: (_) {
          submit();
        },
        validator: validator.validateEmail,
        decoration: InputDecoration(labelText: localization.login_email),
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: "E-Mail Adresse ändern",
              width: maxWidth / 2 - 20,
              onTap: () {
                submit();
              })
        ],
      )
    ]);
  }
}
