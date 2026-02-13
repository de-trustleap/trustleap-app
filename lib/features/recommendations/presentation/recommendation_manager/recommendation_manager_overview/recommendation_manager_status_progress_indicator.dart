import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerStatusProgressIndicator extends StatelessWidget {
  final StatusLevel level;
  final Map<int, DateTime?> statusTimestamps;
  RecommendationManagerStatusProgressIndicator(
      {super.key, required this.level, required this.statusTimestamps});

  final List<IconData> icons = [
    Icons.person_add,
    Icons.mouse,
    Icons.send,
    Icons.calendar_month,
    Icons.check,
    Icons.warning
  ];

  static const double circleSize = 40;
  static const circleAreaSize = 100.0;
  static const double lineThickness = 2;
  static const double spacing = 16;

  int _getIntFromStatusLevel() {
    switch (level) {
      case StatusLevel.recommendationSend:
        return 0;
      case StatusLevel.linkClicked:
        return 1;
      case StatusLevel.contactFormSent:
        return 2;
      case StatusLevel.appointment:
        return 3;
      case StatusLevel.successful:
        return 4;
      case StatusLevel.failed:
        return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final showVertical = responsiveValue.screenWidth > 1150 ? false : true;
    final statusLevel = _getIntFromStatusLevel();

    final bool showWarning = level == StatusLevel.failed;
    final List<IconData> displayIcons =
        showWarning ? [...icons.sublist(0, 4), icons[5]] : icons.sublist(0, 5);

    final List<String> displayLabels = showWarning
        ? [
            localization.recommendation_manager_status_level_1,
            localization.recommendation_manager_status_level_2,
            localization.recommendation_manager_status_level_3,
            localization.recommendation_manager_status_level_4,
            localization.recommendation_manager_status_level_6,
          ]
        : [
            localization.recommendation_manager_status_level_1,
            localization.recommendation_manager_status_level_2,
            localization.recommendation_manager_status_level_3,
            localization.recommendation_manager_status_level_4,
            localization.recommendation_manager_status_level_5,
          ];

    return showVertical
        ? _buildVerticalLayout(
            context, themeData, displayIcons, displayLabels, statusLevel)
        : _buildHorizontalLayout(
            context, themeData, displayIcons, displayLabels, statusLevel);
  }

  Widget _buildHorizontalLayout(BuildContext context, ThemeData themeData,
      List<IconData> icons, List<String> labels, int statusLevel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final stepCount = icons.length;
        final stepSpacing = (totalWidth - circleAreaSize) / (stepCount - 1);

        return SizedBox(
          height: 100,
          child: Stack(
            children: [
              // Hintergrundlinie: von Mitte des 1. bis Mitte des letzten Kreises
              Positioned(
                top: circleSize / 2 - lineThickness / 2,
                left: circleAreaSize / 2,
                width: stepSpacing * (stepCount - 1),
                child: Container(
                  height: lineThickness,
                  color: Colors.grey[300],
                ),
              ),

              // Fortschrittslinie
              if (statusLevel > 0)
                Positioned(
                  top: circleSize / 2 - lineThickness / 2,
                  left: circleAreaSize / 2,
                  width: stepSpacing * statusLevel.clamp(0, 4),
                  child: Container(
                    height: lineThickness,
                    color: statusLevel == 5
                        ? themeData.colorScheme.error
                        : themeData.colorScheme.primary,
                  ),
                ),

              // Kreise + Texte absolut positioniert
              for (int i = 0; i < stepCount; i++)
                Positioned(
                  left: stepSpacing * i,
                  child: SizedBox(
                    width: circleAreaSize,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: circleSize,
                            height: circleSize,
                            child: _buildStepCircle(
                                i, icons[i], themeData, statusLevel),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          labels[i],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (statusTimestamps.containsKey(i) &&
                            statusTimestamps[i] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            DateTimeFormatter().getStringFromDate(
                                context, statusTimestamps[i]!),
                            style: TextStyle(
                              fontSize: 10,
                              color: themeData.colorScheme.surfaceTint
                                  .withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          )
                        ]
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerticalLayout(BuildContext context, ThemeData themeData,
      List<IconData> icons, List<String> labels, int statusLevel) {
    return Column(
      children: List.generate(icons.length, (index) {
        final isLast = index == icons.length - 1;

        final isCompleted = statusLevel > index;
        final isCurrent = statusLevel == index;
        final isSpecialLast = index == 4 && statusLevel == 5;

        final circleColor = isSpecialLast
            ? themeData.colorScheme.error
            : (isCompleted || (index == 4 && statusLevel >= 4))
                ? themeData.colorScheme.primary
                : isCurrent
                    ? Colors.amber
                    : Colors.grey[300]!;

        final iconColor =
            (isCompleted || isCurrent || (index == 4 && statusLevel >= 4))
                ? Colors.white
                : Colors.black26;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icons[index], color: iconColor),
                ),
                if (!isLast)
                  Container(
                    width: lineThickness,
                    height: spacing,
                    color: statusLevel > index
                        ? (statusLevel == 5 && index == 3
                            ? themeData.colorScheme.error
                            : themeData.colorScheme.primary)
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[index],
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (statusTimestamps.containsKey(index) &&
                        statusTimestamps[index] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        DateTimeFormatter().getStringFromDate(
                            context, statusTimestamps[index]!),
                        style: TextStyle(
                          fontSize: 10,
                          color: themeData.colorScheme.surfaceTint
                              .withValues(alpha: 0.6),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStepCircle(
      int index, IconData icon, ThemeData themeData, int statusLevel) {
    final isCompleted = statusLevel > index || statusLevel == 4;
    final isCurrent = statusLevel == index;

    Color bgColor;
    Color iconColor;

    final isWarningStep = statusLevel == 5 && index == 4;

    if (isWarningStep) {
      bgColor = themeData.colorScheme.error;
      iconColor = Colors.white;
    } else {
      bgColor = isCompleted
          ? themeData.colorScheme.primary
          : isCurrent
              ? Colors.amber
              : Colors.grey[300]!;
      iconColor = (isCompleted || isCurrent) ? Colors.white : Colors.black26;
    }

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor),
    );
  }
}
