import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/subtle_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String leadName;
  final bool showError;
  final bool disabled;
  final void Function()? onSendPressed;
  final void Function()? onEmailSendPressed;

  const RecommendationTextField({
    super.key,
    required this.controller,
    required this.leadName,
    required this.showError,
    this.disabled = false,
    this.onSendPressed,
    this.onEmailSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormTextfield(
          controller: controller,
          disabled: false,
          placeholder:
              localization.recommendation_message_template(leadName),
          minLines: 6,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 8),
        if (showError) ...[
          Text(
            localization.send_recommendation_missing_link_text,
            style: themeData.textTheme.bodySmall!
                .copyWith(color: themeData.colorScheme.error),
          ),
          const SizedBox(height: 8),
        ],
        ResponsiveRowColumn(
          layout: ResponsiveHelper.of(context).isMobile
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowSpacing: 8,
          columnSpacing: 8,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: SubtleButton(
                title: localization
                    .recommendation_page_leadTextField_send_button,
                icon: Icons.chat,
                onTap: onSendPressed,
                disabled: disabled,
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: SubtleButton(
                title: localization
                    .recommendation_page_leadTextField_send_email_button,
                icon: Icons.email_outlined,
                onTap: onEmailSendPressed,
                disabled: disabled,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
