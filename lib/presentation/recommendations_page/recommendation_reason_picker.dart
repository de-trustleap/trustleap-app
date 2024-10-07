// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationReaseonPicker extends StatefulWidget {
  final double width;
  final String? validate;
  final List<Map<String, Object?>> reasons;
  final String initialValue;
  final Function onSelected;

  const RecommendationReaseonPicker({
    super.key,
    required this.width,
    required this.validate,
    required this.reasons,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<RecommendationReaseonPicker> createState() =>
      _RecommendationReaseonPickerState();
}

class _RecommendationReaseonPickerState
    extends State<RecommendationReaseonPicker> {
  List<DropdownMenuEntry<String>> dropdownItems = [];

  @override
  void initState() {
    super.initState();

    dropdownItems = createDropdownEntries(widget.reasons);
  }

  List<DropdownMenuEntry<String>> createDropdownEntries(
      List<Map<String, Object?>> reasons) {
    List<DropdownMenuEntry<String>> entries = [];
    for (var reason in reasons) {
      var entry = DropdownMenuEntry<String>(
          value: reason['name'] as String,
          label: (reason['isActive'] == true ? '' : 'DEAKTIVIERT: ') +
              (reason['name'] as String),
          enabled: reason['isActive'] == true);
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
              onSelected: (reason) {
                widget.onSelected(reason);
              }),
        ),
      );
    });
  }
}
