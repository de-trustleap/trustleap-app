import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/feedback/feedback_dialog.dart';
import 'package:flutter/material.dart';

class FeedbackFloatingActionButton extends StatelessWidget {
  const FeedbackFloatingActionButton({super.key});

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FeedbackDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return FloatingActionButton(
      onPressed: () => _showFeedbackDialog(context),
      backgroundColor: themeData.colorScheme.secondary,
      foregroundColor: Colors.white,
      tooltip: localizations.feedback_send_button,
      child: const Icon(Icons.feedback_outlined),
    );
  }
}
