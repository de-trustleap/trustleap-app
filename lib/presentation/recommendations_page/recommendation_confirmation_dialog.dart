import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class RecommendationConfirmationDialog extends StatelessWidget {
  final VoidCallback cancelAction;
  final VoidCallback action;

  const RecommendationConfirmationDialog(
      {super.key, required this.cancelAction, required this.action});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return CustomAlertDialog(
        title: localization.send_recommendation_alert_title,
        message: localization.send_recommendation_alert_description,
        actionButtonTitle: localization.send_recommendation_alert_yes_button,
        cancelButtonTitle: localization.send_recommendation_alert_no_button,
        actionButtonAction: action,
        cancelButtonAction: cancelAction);
  }
}
