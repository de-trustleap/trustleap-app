import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
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
                false,
              ),
              _buildCustomStep(
                context,
                2,
                "Unternehmen registrieren",
                "Gehe in dein Profil und registriere dein Unternehmen",
                "Zum Profil",
                RoutePaths.homePath + RoutePaths.profilePath,
                false,
              ),
              _buildCustomStep(
                context,
                3,
                "Warten auf Freischaltung",
                "Du hast eine Registrierungsanfrage für dein Unternehmen gestellt. Die Bearbeitung der Anfrage kann ein paar Tage dauern. Schaue später nochmal vorbei.",
                null,
                null,
                false,
              ),
              _buildCustomStep(
                context,
                4,
                "Default Landingpage anlegen",
                "Für die Nutzung der App musst du eine Default Landingpage anlegen. Auf diese wird zurückgergiffen, falls deine normale Landingpage nicht funktioniert.",
                "Zu den Landingpages",
                RoutePaths.homePath + RoutePaths.landingPagePath,
                false,
              ),
              _buildCustomStep(
                context,
                5,
                "Landingpage erstellen",
                "Du hast deine Default Landingpage erfolgreich erstellt. Jetzt wird noch eine normale Landingpage benötigt, um dein Produkt oder deine Dienstleistung zu bewerben.",
                "Zu den Landingpages",
                RoutePaths.homePath + RoutePaths.landingPagePath,
                false,
              ),
              _buildCustomStep(
                context,
                6,
                "Promoter registrieren",
                "Um deine Dienstleistung oder dein Produkt zu bewerben sind Promoter notwendig. Erstelle deinen ersten Promoter.",
                "Promoter registrieren",
                RoutePaths.homePath + RoutePaths.promotersPath,
                false,
              ),
              _buildCustomStep(
                context,
                7,
                "Auf Promoter warten",
                "Der eingeladene Promoter muss sich jetzt registrieren. Bitte warte bis das geschehen ist.",
                null,
                null,
                false,
              ),
              _buildCustomStep(
                context,
                8,
                "Empfehlung aussprechen",
                "Es ist an der Zeit deine erste Empfehlung auszusprechen, um deinen ersten Kunden zu gewinnen.",
                "Empfehlung aussprechen",
                RoutePaths.homePath + RoutePaths.recommendationsPath,
                false,
              ),
              _buildCustomStep(
                context,
                9,
                "Empfehlungsmanager überprüfen",
                "Deine erste Empfehlung wird jetzt im Empfehlungsmanager angezeigt. Hier kannst du die Empfehlung priorisieren, Notizen hinterlassen und den Status deiner Empfehlung überprüfen. Außerdem siehst du hier auch alle Empfehlungen die deine Promoter ausgesprochen haben.",
                "Zum Empfehlungsmanager",
                RoutePaths.homePath + RoutePaths.recommendationManagerPath,
                true,
              ),
              _buildCustomStep(
                context,
                10,
                "Tutorial abschließen",
                "Du hast alle Schritte zur Nutzung der App abgeschlossen.",
                "Zum Empfehlungsmanager",
                RoutePaths.homePath + RoutePaths.recommendationManagerPath,
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
    String? buttonText,
    String? buttonPath,
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
                    color:
                        themeData.colorScheme.onSurface.withValues(alpha: 0.3),
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
                  if (buttonText != null && buttonPath != null && !isLast) ...[
                    TextButton(
                      onPressed: () => CustomNavigator.navigate(buttonPath),
                      child: Text(
                        buttonText,
                        style: themeData.textTheme.bodySmall!
                            .copyWith(color: themeData.colorScheme.secondary),
                      ),
                    ),
                  ] else if (buttonText != null && isLast) ...[
                    PrimaryButton(
                        title: "Tutorial ausblenden",
                        width: 300,
                        onTap: () => {print("TAPPED!")})
                  ]
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
