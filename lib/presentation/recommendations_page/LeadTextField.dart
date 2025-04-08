import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class LeadTextField extends StatelessWidget {
  final TextEditingController controller;
  final String leadName;
  final void Function()? onSendPressed;

  const LeadTextField({
    Key? key,
    required this.controller,
    required this.leadName,
    this.onSendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
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
        PrimaryButton(
            title: localization.recommendation_page_leadTextField_send_button,
            onTap: onSendPressed,
            icon: Icons.send),
      ],
    );
  }
}
