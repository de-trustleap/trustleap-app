import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerStatusProgressIndicator extends StatelessWidget {
  final int level;
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

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final showVertical = responsiveValue.screenWidth > 1150 ? false : true;

    final List<String> labels = [
      localization.recommendation_manager_status_level_1,
      localization.recommendation_manager_status_level_2,
      localization.recommendation_manager_status_level_3,
      localization.recommendation_manager_status_level_4,
      localization.recommendation_manager_status_level_5,
      localization.recommendation_manager_status_level_6
    ];

    return showVertical
        ? _buildVerticalLayout(context, themeData, labels)
        : _buildHorizontalLayout(context, themeData, labels);
  }

  Widget _buildHorizontalLayout(
      BuildContext context, ThemeData themeData, List<String> labels) {
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
              if (level > 0)
                Positioned(
                  top: circleSize / 2 - lineThickness / 2,
                  left: circleAreaSize / 2,
                  width: stepSpacing * level,
                  child: Container(
                    height: lineThickness,
                    color: level == 5 ? Colors.red : Colors.green,
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
                            child: _buildStepCircle(i),
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
                                  .withOpacity(0.6),
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

  Widget _buildVerticalLayout(
      BuildContext context, ThemeData themeData, List<String> labels) {
    return Column(
      children: List.generate(icons.length, (index) {
        final isLast = index == icons.length - 1;

        final isCompleted = level > index;
        final isCurrent = level == index;
        final isSpecialLast = index == 4 && level == 5;

        final circleColor = isSpecialLast
            ? Colors.red
            : (isCompleted || (index == 4 && level >= 4))
                ? Colors.green
                : isCurrent
                    ? Colors.amber
                    : Colors.grey[300]!;

        final iconColor =
            (isCompleted || isCurrent || (index == 4 && level >= 4))
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
                    color: level > index
                        ? (level == 5 && index == 3 ? Colors.red : Colors.green)
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

  Widget _buildStepCircle(int index) {
    final isCompleted = level > index;
    final isCurrent = level == index;

    Color bgColor;
    Color iconColor;

    if (index == 4) {
      if (level == 5) {
        bgColor = Colors.red;
        iconColor = Colors.white;
      } else if (level >= 4) {
        bgColor = Colors.green;
        iconColor = Colors.white;
      } else {
        bgColor = Colors.grey[300]!;
        iconColor = Colors.black26;
      }
    } else {
      bgColor = isCompleted
          ? Colors.green
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
      child: Icon(
        icons[index],
        color: iconColor,
      ),
    );
  }
}

// TODO: ES SOLL EINE BUTTON REIHE GEBEN. (CALENDAR, HÄKCHEN, KREUZ, TRASH) FÜR (TERMINIEREN, ABGESCHLOSSEN, NICHT ABGESCHLOSSEN, LÖSCHEN)
// TODO: ABGESCHLOSSEN UND NICHT ABGESCHLOSSEN STATE VEREINEN
// TODO: FRONTEND TESTS
