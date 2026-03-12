// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_dropdown.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_reason.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationReasonPicker extends StatelessWidget {
  final double width;
  final String? validate;
  final List<RecommendationReason> reasons;
  final String initialValue;
  final Function(RecommendationReason?) onSelected;

  const RecommendationReasonPicker({
    super.key,
    required this.width,
    required this.validate,
    required this.reasons,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    final items = reasons.map((reason) {
      final label = (reason.isActive == true ? '' : 'DEAKTIVIERT: ') +
          (reason.reason as String);
      return CustomDropdownItem<String>(
        value: reason.reason as String,
        label: label,
        enabled: reason.isActive == true,
      );
    }).toList();

    return FormField(builder: (FormFieldState<String> state) {
      return SizedBox(
        width: width,
        child: InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorText: validate,
          ),
          child: CustomDropdown<String>(
            width: width,
            label: localization.recommendations_choose_reason_placeholder,
            value: initialValue,
            type: CustomDropdownType.standard,
            items: items,
            onChanged: (selectedReason) {
              if (selectedReason == null) return;
              final selectedRecommendationReason = reasons
                  .firstWhere((reason) => reason.reason == selectedReason);
              onSelected(selectedRecommendationReason);
            },
          ),
        ),
      );
    });
  }
}
