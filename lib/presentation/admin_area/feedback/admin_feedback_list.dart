import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/feedback/admin_feedback_list_tile.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';

class AdminFeedbackList extends StatelessWidget {
  final List<FeedbackItem> feedbackItems;
  const AdminFeedbackList({super.key, required this.feedbackItems});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return CardContainer(
        maxWidth: 1200,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            localizations.admin_feedback_list_title,
            style: themeData.textTheme.headlineLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            itemCount: feedbackItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                AdminFeedbackListTile(feedbackItem: feedbackItems[index]),
          )
        ]));
  }
}
