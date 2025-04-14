// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/recommendation_reason.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationReasonPicker extends StatefulWidget {
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
  State<RecommendationReasonPicker> createState() =>
      _RecommendationReaseonPickerState();
}

class _RecommendationReaseonPickerState
    extends State<RecommendationReasonPicker> {
  List<DropdownMenuEntry<String>> dropdownItems = [];

  @override
  void initState() {
    super.initState();

    dropdownItems = createDropdownEntries(widget.reasons);
  }

  List<DropdownMenuEntry<String>> createDropdownEntries(
      List<RecommendationReason> reasons) {
    List<DropdownMenuEntry<String>> entries = [];
    for (var reason in reasons) {
      var entry = DropdownMenuEntry<String>(
          value: reason.reason as String,
          label: (reason.isActive == true ? '' : 'DEAKTIVIERT: ') +
              (reason.reason as String),
          enabled: reason.isActive == true);
      entries.add(entry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return FormField(builder: (FormFieldState<String> state) {
      return SizedBox(
        width: widget.width,
        child: InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorText: widget.validate,
          ),
          child: DropdownMenu<String>(
              width: widget.width,
              label: Text(
                  localization.recommendations_choose_reason_placeholder,
                  style: responsiveValue.isMobile
                      ? themeData.textTheme.bodySmall
                      : themeData.textTheme.bodyMedium),
              initialSelection: widget.initialValue,
              enableSearch: false,
              requestFocusOnTap: false,
              dropdownMenuEntries: dropdownItems,
              onSelected: (selectedReason) {
                final selectedRecommendationReason = widget.reasons
                    .firstWhere((reason) => reason.reason == selectedReason);
                widget.onSelected(selectedRecommendationReason);
              }),
        ),
      );
    });
  }
}
