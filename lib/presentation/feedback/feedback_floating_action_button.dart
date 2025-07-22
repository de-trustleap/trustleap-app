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

    return FloatingActionButton(
      onPressed: () => _showFeedbackDialog(context),
      backgroundColor: themeData.colorScheme.secondary,
      foregroundColor: Colors.white,
      tooltip: 'Feedback senden', // TODO: Add to localization
      child: const Icon(Icons.feedback_outlined),
    );
  }
}
