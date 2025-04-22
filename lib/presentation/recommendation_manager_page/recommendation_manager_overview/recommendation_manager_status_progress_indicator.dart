import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
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

  final List<String> labels = [
    "Empfehlung ausgesprochen",
    "Link geklickt",
    "Kontakt aufgenommen",
    "Empfehlung terminiert",
    "Abgeschlossen",
    "Nicht abgeschlossen"
  ];

  static const double circleSize = 40;
  static const double lineThickness = 2;
  static const double spacing = 16;

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);
    final showVertical = responsiveValue.screenWidth > 1150 ? false : true;

    return showVertical
        ? _buildVerticalLayout(context, themeData)
        : _buildHorizontalLayout(context, themeData);
  }

  Widget _buildHorizontalLayout(BuildContext context, ThemeData themeData) {
    const double stepWidth = 120;

    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          // Hintergrundlinie
          Positioned(
            top: circleSize / 2 - lineThickness / 2,
            left: stepWidth / 2,
            right: stepWidth / 2,
            child: Container(
              height: lineThickness,
              color: Colors.grey[300],
            ),
          ),
          // Fortschrittslinie
          if (level > 0)
            Positioned(
              top: circleSize / 2 - lineThickness / 2,
              left: stepWidth / 2,
              right: stepWidth * (icons.length - level - 0.5),
              child: Container(
                height: lineThickness,
                color: level == 5 ? Colors.red : Colors.green,
              ),
            ),
          // Kreise + Texte
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(icons.length, (index) {
              return SizedBox(
                width: stepWidth,
                child: Column(
                  children: [
                    _buildStepCircle(index),
                    const SizedBox(height: 8),
                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
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
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, ThemeData themeData) {
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

// TODO: EMPFEHLUNG LÖSCHEN FUNKTION (CLOUD FUNCTION)
// TODO: ONSCHEDULE FUNCTION ANPASSEN UND DORT AUCH RECO ID VON USER LÖSCHEN. DAFÜR MUSS USERID AUCH IN RECO ITEM GESPEICHERT WERDEN
// TODO: LOCALIZATION
