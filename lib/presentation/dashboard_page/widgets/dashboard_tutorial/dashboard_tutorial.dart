import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';

class DashboardTutorial extends StatefulWidget {
  final CustomUser user;
  const DashboardTutorial({super.key, required this.user});

  @override
  State<DashboardTutorial> createState() => _DashboardTutorialState();
}

class _DashboardTutorialState extends State<DashboardTutorial> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CardContainer(
        maxWidth: 1000,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Kleine Starthilfe",
            style: themeData.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildCustomStep(
                context,
                0,
                "E-Mail Adresse verifizieren",
                "Verifiziere deine E-Mail Adresse. Um den Verifizierungslink erneut zu senden, besuche dein Profil.",
                "Zum Profil",
                RoutePaths.homePath + RoutePaths.profilePath,
                false,
              ),
              _buildCustomStep(
                context,
                1,
                "Kontaktdaten vervollständigen",
                "Gehe in dein Profil und vervollständige deine Kontaktdaten.",
                "Zum Profil",
                RoutePaths.homePath + RoutePaths.profilePath,
                true,
              ),
            ],
          )
        ]));
  }

  Widget _buildCustomStep(
    BuildContext context,
    int stepIndex,
    String title,
    String content,
    String buttonText,
    String buttonPath,
    bool isLast,
  ) {
    final themeData = Theme.of(context);
    final isActive = stepIndex == _currentStep;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isActive
                    ? themeData.colorScheme.primary
                    : themeData.colorScheme.onSurface.withValues(alpha: 0.3),
                child: Text(
                  '${stepIndex + 1}',
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: isActive
                        ? themeData.colorScheme.onPrimary
                        : themeData.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: themeData.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                if (isActive) ...[
                  const SizedBox(height: 8),
                  Text(content, style: themeData.textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => CustomNavigator.navigate(buttonPath),
                    child: Text(
                      buttonText,
                      style: themeData.textTheme.bodySmall!
                          .copyWith(color: themeData.colorScheme.secondary),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
