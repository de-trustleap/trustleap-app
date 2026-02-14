import 'package:finanzbegleiter/features/consent/application/consent_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/consent/presentation/cookie_consent_texts.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/outlined_custom_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CookieSettingsDialog extends StatefulWidget {
  final VoidCallback? onClose;

  const CookieSettingsDialog({super.key, this.onClose});

  @override
  State<CookieSettingsDialog> createState() => _CookieSettingsDialogState();
}

class _CookieSettingsDialogState extends State<CookieSettingsDialog> {
  final Set<ConsentCategory> _selectedCategories = {ConsentCategory.necessary};

  @override
  void initState() {
    super.initState();
    final cubit = Modular.get<ConsentCubit>();
    final currentPreferences = cubit.getCurrentPreferences();
    _selectedCategories.addAll(currentPreferences.categories);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final texts = CookieConsentTexts(AppLocalizations.of(context));

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texts.settingsTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                texts.settingsDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _buildCategoryCard(
                context: context,
                title: texts.categoryNecessaryTitle,
                description: texts.categoryNecessaryDescription,
                services: texts.categoryNecessaryServices,
                category: ConsentCategory.necessary,
                isAlwaysActive: true,
                alwaysActiveText: texts.alwaysActive,
              ),
              const SizedBox(height: 16),
              _buildCategoryCard(
                context: context,
                title: texts.categoryStatisticsTitle,
                description: texts.categoryStatisticsDescription,
                services: texts.categoryStatisticsServices,
                category: ConsentCategory.statistics,
                isAlwaysActive: false,
                alwaysActiveText: texts.alwaysActive,
              ),
              const SizedBox(height: 24),
              ResponsiveRowColumn(
                layout: responsiveValue.isMobile
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                rowMainAxisAlignment: MainAxisAlignment.end,
                columnCrossAxisAlignment: CrossAxisAlignment.stretch,
                columnSpacing: 12,
                rowSpacing: 16,
                children: [
                  ResponsiveRowColumnItem(
                    child: OutlinedCustomButton(
                      title: texts.settingsCancel,
                      width: responsiveValue.isMobile ? double.infinity : 120,
                      onTap: () {
                        if (widget.onClose != null) {
                          widget.onClose!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    child: PrimaryButton(
                      title: texts.settingsSave,
                      width: responsiveValue.isMobile ? double.infinity : 230,
                      onTap: () => _savePreferences(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String description,
    required String services,
    required ConsentCategory category,
    required bool isAlwaysActive,
    required String alwaysActiveText,
  }) {
    final isSelected = _selectedCategories.contains(category);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (isAlwaysActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      alwaysActiveText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                else
                  Switch(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              services,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _savePreferences(BuildContext context) {
    final cubit = Modular.get<ConsentCubit>();
    cubit.saveCustomConsent(_selectedCategories);

    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      CustomNavigator.of(context).pop();
    }
  }
}
