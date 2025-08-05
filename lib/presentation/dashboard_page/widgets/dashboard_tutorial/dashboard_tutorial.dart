import 'package:finanzbegleiter/application/dashboard/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardTutorial extends StatefulWidget {
  final CustomUser user;
  final VoidCallback onUserUpdate;
  const DashboardTutorial(
      {super.key, required this.user, required this.onUserUpdate});

  @override
  State<DashboardTutorial> createState() => _DashboardTutorialState();
}

class _DashboardTutorialState extends State<DashboardTutorial> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    Modular.get<DashboardTutorialCubit>().getStep(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = Modular.get<DashboardTutorialCubit>();
    return BlocBuilder<DashboardTutorialCubit, DashboardTutorialState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is DashboardTutorialSuccess) {
          _currentStep = state.currentStep;
        }

        if (state is DashboardTutorialFailure) {
          return ErrorView(
              title: "Abruf des Tutorials fehlgeschlagen",
              message:
                  "Der Aufruf ist fehlgeschlagen. Versuche es bitte erneut.",
              callback: () =>
                  Modular.get<DashboardTutorialCubit>().getStep(widget.user));
        } else {
          return CardContainer(
              maxWidth: 1000,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          () => CustomNavigator.navigate(
                              RoutePaths.homePath + RoutePaths.profilePath),
                          false,
                        ),
                        _buildCustomStep(
                          context,
                          1,
                          "Kontaktdaten vervollständigen",
                          "Gehe in dein Profil und vervollständige deine Kontaktdaten.",
                          "Zum Profil",
                          () {
                            CustomNavigator.navigate(
                                RoutePaths.homePath + RoutePaths.profilePath);
                            cubit.setStep(widget.user, 2);
                          },
                          false,
                        ),
                        _buildCustomStep(
                          context,
                          2,
                          "Unternehmen registrieren",
                          "Gehe in dein Profil und registriere dein Unternehmen",
                          "Zum Profil",
                          () => CustomNavigator.navigate(
                              RoutePaths.homePath + RoutePaths.profilePath),
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
                          () => CustomNavigator.navigate(
                              RoutePaths.homePath + RoutePaths.landingPagePath),
                          false,
                        ),
                        _buildCustomStep(
                          context,
                          5,
                          "Landingpage erstellen",
                          "Du hast deine Default Landingpage erfolgreich erstellt. Jetzt wird noch eine normale Landingpage benötigt, um dein Produkt oder deine Dienstleistung zu bewerben.",
                          "Zu den Landingpages",
                          () => CustomNavigator.navigate(
                              RoutePaths.homePath + RoutePaths.landingPagePath),
                          false,
                        ),
                        _buildCustomStep(
                          context,
                          6,
                          "Promoter registrieren",
                          "Um deine Dienstleistung oder dein Produkt zu bewerben sind Promoter notwendig. Erstelle deinen ersten Promoter.",
                          "Promoter registrieren",
                          () => CustomNavigator.navigate(
                              RoutePaths.homePath + RoutePaths.promotersPath),
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
                          () => CustomNavigator.navigate(RoutePaths.homePath +
                              RoutePaths.recommendationsPath),
                          false,
                        ),
                        _buildCustomStep(
                          context,
                          9,
                          "Empfehlungsmanager überprüfen",
                          "Deine erste Empfehlung wird jetzt im Empfehlungsmanager angezeigt. Hier kannst du die Empfehlung priorisieren, Notizen hinterlassen und den Status deiner Empfehlung überprüfen. Außerdem siehst du hier auch alle Empfehlungen die deine Promoter ausgesprochen haben.",
                          "Zum Empfehlungsmanager",
                          () {
                            CustomNavigator.navigate(RoutePaths.homePath +
                                RoutePaths.recommendationManagerPath);
                            cubit.setStep(widget.user, 10);
                          },
                          false,
                        ),
                        _buildCustomStep(
                          context,
                          10,
                          "Tutorial abschließen",
                          "Du hast alle Schritte zur Nutzung der App abgeschlossen.",
                          null,
                          null,
                          true,
                        ),
                      ],
                    )
                  ]));
        }
      },
    );
  }

  Widget _buildCustomStep(
    BuildContext context,
    int stepIndex,
    String title,
    String content,
    String? buttonText,
    VoidCallback? buttonAction,
    bool isLast,
  ) {
    final themeData = Theme.of(context);
    final isActive = stepIndex == _currentStep;
    final isCompleted = stepIndex < _currentStep;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isCompleted
                    ? themeData.colorScheme.primary
                    : isActive
                        ? themeData.colorScheme.secondary
                        : themeData.colorScheme.onSurface
                            .withValues(alpha: 0.3),
                child: Text(
                  '${stepIndex + 1}',
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: isCompleted
                        ? themeData.colorScheme.onPrimary
                        : isActive
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
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCompleted
                        ? themeData.textTheme.bodyMedium!.color
                            ?.withValues(alpha: 0.5)
                        : null,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(height: 8),
                  Text(content, style: themeData.textTheme.bodyMedium),
                  if (buttonText != null &&
                      buttonAction != null &&
                      !isLast) ...[
                    TextButton(
                      onPressed: buttonAction,
                      child: Text(
                        buttonText,
                        style: themeData.textTheme.bodySmall!
                            .copyWith(color: themeData.colorScheme.secondary),
                      ),
                    ),
                  ] else if (isLast) ...[
                    const SizedBox(height: 8),
                    PrimaryButton(
                        title: "Tutorial ausblenden",
                        width: 300,
                        onTap: () {
                          Modular.get<DashboardTutorialCubit>()
                              .setStep(widget.user, null);
                          widget.onUserUpdate();
                        })
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
