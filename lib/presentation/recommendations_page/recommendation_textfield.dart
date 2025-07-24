import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RecommendationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String leadName;
  final bool showError;
  final void Function()? onSendPressed;
  final VoidCallback? onMailPressed;

  const RecommendationTextField({
    super.key,
    required this.controller,
    required this.leadName,
    required this.showError,
    this.onSendPressed,
    this.onMailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: FormTextfield(
              controller: controller,
              disabled: false,
              placeholder:
                  "${localization.recommendation_page_leadTextField_title_prefix} $leadName",
              minLines: 10,
              maxLines: 10,
              keyboardType: TextInputType.multiline),
        ),
        const SizedBox(height: 10),
        if (showError) ...[
          Text(localization.send_recommendation_missing_link_text,
              style: themeData.textTheme.bodySmall!
                  .copyWith(color: themeData.colorScheme.error))
        ],
        const SizedBox(height: 20),
        PrimaryButton(
            title: localization.recommendation_page_leadTextField_send_button,
            onTap: onSendPressed,
            icon: Icons.send),
        const SizedBox(height: 12),
        PrimaryButton(
          title: localization.recommendation_page_leadTextField_send_Mail_button,
          onTap: onMailPressed,
          icon: Icons.email,
        ),
      ],
    );
  }
}
