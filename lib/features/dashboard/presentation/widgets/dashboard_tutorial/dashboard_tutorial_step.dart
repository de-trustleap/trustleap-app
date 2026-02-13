import 'package:finanzbegleiter/features/dashboard/application/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardTutorialStep extends StatelessWidget {
  final int stepIndex;
  final int currentStep;
  final String title;
  final String content;
  final String? buttonText;
  final VoidCallback? buttonAction;
  final bool isLast;
  final CustomUser user;

  const DashboardTutorialStep({
    super.key,
    required this.stepIndex,
    required this.currentStep,
    required this.title,
    required this.content,
    this.buttonText,
    this.buttonAction,
    required this.isLast,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final isActive = stepIndex == currentStep;
    final isCompleted = stepIndex < currentStep;

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
                        buttonText!,
                        style: themeData.textTheme.bodySmall!
                            .copyWith(color: themeData.colorScheme.secondary),
                      ),
                    ),
                  ] else if (isLast) ...[
                    const SizedBox(height: 8),
                    PrimaryButton(
                        title: localization
                            .dashboard_tutorial_button_hide_tutorial,
                        width: 300,
                        onTap: () {
                          Modular.get<DashboardTutorialCubit>()
                              .setStep(user, null);
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
