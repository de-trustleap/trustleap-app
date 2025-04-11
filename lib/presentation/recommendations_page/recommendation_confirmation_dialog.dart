import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class RecommendationConfirmationDialog extends StatelessWidget {
  final VoidCallback cancelAction;
  final VoidCallback action;

  const RecommendationConfirmationDialog(
      {super.key, required this.cancelAction, required this.action});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
        title: "Empfehlung verschickt?",
        message:
            "Hast du die Empfehlung erfolgreich verschickt? Der Link in der Empfehlung wird erst gültig wenn du hier bestätigst.",
        actionButtonTitle: "Ja",
        cancelButtonTitle: "Nein",
        actionButtonAction: action,
        cancelButtonAction: cancelAction);
  }
}
