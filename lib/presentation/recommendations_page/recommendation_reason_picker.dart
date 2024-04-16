// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationReaseonPicker extends StatelessWidget {
  final double width;
  final String? validate;
  final RecommendationReason? initialValue;
  final Function onSelected;

  const RecommendationReaseonPicker({
    Key? key,
    required this.width,
    required this.validate,
    this.initialValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return FormField(builder: (FormFieldState<RecommendationReason> state) {
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
          child: DropdownMenu<RecommendationReason>(
              width: width,
              label: Text(
                  localization.recommendations_choose_reason_placeholder,
                  style: responsiveValue.isMobile
                      ? themeData.textTheme.bodySmall
                      : themeData.textTheme.bodyMedium),
              initialSelection: initialValue ?? RecommendationReason.none,
              enableSearch: false,
              requestFocusOnTap: false,
              dropdownMenuEntries: [
                DropdownMenuEntry(
                    value: RecommendationReason.none,
                    label:
                        localization.recommendations_choose_reason_not_chosen),
                const DropdownMenuEntry(
                    value: RecommendationReason.finance,
                    label: "Finanzdienstleistung"),
                const DropdownMenuEntry(
                    value: RecommendationReason.insurance,
                    label: "Versicherungsdienstleistung"),
                const DropdownMenuEntry(
                    value: RecommendationReason.car,
                    label: "KFZ-Dienstleistung")
              ],
              onSelected: (reason) {
                onSelected(reason);
              }),
        ),
      );
    });
  }
}
