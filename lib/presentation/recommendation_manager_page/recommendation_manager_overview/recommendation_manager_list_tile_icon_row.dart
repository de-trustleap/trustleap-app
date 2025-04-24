import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationManagerListTileIconRow extends StatelessWidget {
  final RecommendationItem recommendation;
  final Function(RecommendationItem) onAppointmentPressed;
  final Function(String) onFinishedPressed;
  final Function(String) onFailedPressed;
  final Function(String, String) onDeletePressed;
  const RecommendationManagerListTileIconRow(
      {super.key,
      required this.recommendation,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Row(children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Tooltip(
                message: "Als terminiert markieren",
                child: ElevatedButton(
                    onPressed: recommendation.statusLevel == 2
                        ? () => onAppointmentPressed(recommendation)
                        : null,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: themeData.colorScheme.secondary),
                    child:
                        const Icon(Icons.calendar_month, color: Colors.white)),
              ))),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Tooltip(
                message: "Als abgeschlossen markieren",
                child: ElevatedButton(
                    onPressed: recommendation.statusLevel == 3
                        ? () => onFinishedPressed(recommendation.id)
                        : null,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: themeData.colorScheme.secondary),
                    child: const Icon(Icons.check, color: Colors.white)),
              ))),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Tooltip(
                message: "Als nicht abgeschlossen markieren",
                child: ElevatedButton(
                    onPressed: recommendation.statusLevel == 3
                        ? () => onFailedPressed(recommendation.id)
                        : null,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: themeData.colorScheme.secondary),
                    child: const Icon(Icons.close, color: Colors.white)),
              ))),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Tooltip(
                message: localization
                    .recommendation_manager_list_tile_delete_button_title,
                child: ElevatedButton(
                    onPressed: () => onDeletePressed(
                        recommendation.id, recommendation.userID ?? ""),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: themeData.colorScheme.secondary),
                    child: const Icon(Icons.delete, color: Colors.white)),
              )))
    ]);
  }
}
