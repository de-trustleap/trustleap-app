import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class RecommendationConfirmationDialogError extends StatelessWidget {
  final DatabaseFailure failure;
  final VoidCallback cancelAction;
  final VoidCallback action;
  const RecommendationConfirmationDialogError(
      {super.key,
      required this.failure,
      required this.cancelAction,
      required this.action});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return CustomAlertDialog(
        title: "Empfehlung verschickt?",
        messageWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
                "Hast du die Empfehlung erfolgreich verschickt? Der Link in der Empfehlung wird erst gültig wenn du hier bestätigst.",
                style: themeData.textTheme.bodyMedium),
            const SizedBox(height: 16),
            SelectableText(
                DatabaseFailureMapper.mapFailureMessage(failure, localization),
                style: themeData.textTheme.bodyMedium!
                    .copyWith(color: themeData.colorScheme.error)),
          ],
        ),
        message: "",
        actionButtonTitle: "Ja",
        cancelButtonTitle: "Nein",
        actionButtonAction: action,
        cancelButtonAction: cancelAction);
  }
}
