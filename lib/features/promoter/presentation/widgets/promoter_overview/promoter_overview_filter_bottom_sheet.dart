import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/bottom_sheet_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_dropdown.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:flutter/material.dart';

class PromoterOverviewFilterBottomSheet extends StatefulWidget {
  final PromoterOverviewFilterStates filterStates;
  final Function(PromoterOverviewFilterStates filterStates) onFilterChanged;

  const PromoterOverviewFilterBottomSheet({
    super.key,
    required this.filterStates,
    required this.onFilterChanged,
  });

  @override
  State<PromoterOverviewFilterBottomSheet> createState() =>
      _PromoterOverviewFilterBottomSheetState();
}

class _PromoterOverviewFilterBottomSheetState
    extends State<PromoterOverviewFilterBottomSheet> {
  late PromoterOverviewFilterStates _filterStates;

  @override
  void initState() {
    super.initState();
    _filterStates = PromoterOverviewFilterStates()
      ..registrationFilterState = widget.filterStates.registrationFilterState
      ..sortByFilterState = widget.filterStates.sortByFilterState
      ..sortOrderFilterState = widget.filterStates.sortOrderFilterState;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return BottomSheetWrapper(
      title: localization.promoter_overview_filter_title,
      child: _buildFilterContent(context, themeData, localization),
    );
  }

  Widget _buildFilterContent(BuildContext context, ThemeData themeData,
      AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.promoter_overview_filter_registration_title,
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioGroup<PromoterRegistrationFilterState>(
          groupValue: _filterStates.registrationFilterState,
          onChanged: (PromoterRegistrationFilterState? value) {
            if (value != null) {
              setState(() {
                _filterStates.registrationFilterState = value;
              });
              widget.onFilterChanged(_filterStates);
            }
          },
          child: Column(
            children: [
              RadioListTile<PromoterRegistrationFilterState>(
                title: Text(localization.promoter_overview_filter_show_all),
                value: PromoterRegistrationFilterState.all,
              ),
              RadioListTile<PromoterRegistrationFilterState>(
                title:
                    Text(localization.promoter_overview_filter_show_registered),
                value: PromoterRegistrationFilterState.registered,
              ),
              RadioListTile<PromoterRegistrationFilterState>(
                title: Text(
                    localization.promoter_overview_filter_show_unregistered),
                value: PromoterRegistrationFilterState.unregistered,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          localization.promoter_overview_filter_sortby_title,
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CustomDropdown<PromoterSortByFilterState>(
          label: localization.promoter_overview_filter_sortby_choose,
          value: _filterStates.sortByFilterState,
          type: CustomDropdownType.standard,
          useDialogPicker: true,
          items: [
            CustomDropdownItem(
              value: PromoterSortByFilterState.createdAt,
              label: localization.promoter_overview_filter_sortby_date,
            ),
            CustomDropdownItem(
              value: PromoterSortByFilterState.firstName,
              label: localization.promoter_overview_filter_sortby_firstname,
            ),
            CustomDropdownItem(
              value: PromoterSortByFilterState.lastName,
              label: localization.promoter_overview_filter_sortby_lastname,
            ),
            CustomDropdownItem(
              value: PromoterSortByFilterState.email,
              label: localization.promoter_overview_filter_sortby_email,
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _filterStates.sortByFilterState = value;
              });
              widget.onFilterChanged(_filterStates);
            }
          },
        ),
        const SizedBox(height: 24),
        Text(
          localization.promoter_overview_filter_sortorder_title,
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioGroup<PromoterSortOrderFilterState>(
          groupValue: _filterStates.sortOrderFilterState,
          onChanged: (PromoterSortOrderFilterState? value) {
            if (value != null) {
              setState(() {
                _filterStates.sortOrderFilterState = value;
              });
              widget.onFilterChanged(_filterStates);
            }
          },
          child: Column(
            children: [
              RadioListTile<PromoterSortOrderFilterState>(
                title:
                    Text(localization.promoter_overview_filter_sortorder_desc),
                value: PromoterSortOrderFilterState.desc,
              ),
              RadioListTile<PromoterSortOrderFilterState>(
                title:
                    Text(localization.promoter_overview_filter_sortorder_asc),
                value: PromoterSortOrderFilterState.asc,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
