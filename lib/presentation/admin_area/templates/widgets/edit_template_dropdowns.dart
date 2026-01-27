import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class EditTemplateTypeDropdown extends StatelessWidget {
  final SectionType selectedType;
  final void Function(SectionType) onChanged;

  const EditTemplateTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.admin_area_template_manager_section_type_label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<SectionType>(
            isExpanded: true,
            value: selectedType,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: SectionType.hero,
                child: Text(localization.admin_area_template_manager_type_hero),
              ),
              DropdownMenuItem(
                value: SectionType.product,
                child: Text(localization.admin_area_template_manager_type_product),
              ),
              DropdownMenuItem(
                value: SectionType.about,
                child: Text(localization.admin_area_template_manager_type_about),
              ),
              DropdownMenuItem(
                value: SectionType.callToAction,
                child: Text(
                    localization.admin_area_template_manager_type_call_to_action),
              ),
              DropdownMenuItem(
                value: SectionType.advantages,
                child:
                    Text(localization.admin_area_template_manager_type_advantages),
              ),
              DropdownMenuItem(
                value: SectionType.footer,
                child: Text(localization.admin_area_template_manager_type_footer),
              ),
              DropdownMenuItem(
                value: SectionType.contact,
                child: Text(localization.admin_area_template_manager_type_contact_form),
              ),
              DropdownMenuItem(
                value: SectionType.calendly,
                child: Text(localization.admin_area_template_manager_type_calendly),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

class EditTemplateEnvironmentDropdown extends StatelessWidget {
  final String environment;
  final void Function(String) onChanged;

  const EditTemplateEnvironmentDropdown({
    super.key,
    required this.environment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.admin_area_template_manager_environment_label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: environment,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: "both",
              child:
                  Text(localization.admin_area_template_manager_environment_both),
            ),
            DropdownMenuItem(
              value: "staging",
              child: Text(
                  localization.admin_area_template_manager_environment_staging),
            ),
            DropdownMenuItem(
              value: "prod",
              child:
                  Text(localization.admin_area_template_manager_environment_prod),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }
}
