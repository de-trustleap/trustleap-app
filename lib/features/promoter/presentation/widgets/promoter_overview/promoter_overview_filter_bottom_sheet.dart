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

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.promoter_overview_filter_title,
                style: themeData.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterContent(context, themeData, localization),
          const SizedBox(height: 16),
        ],
      ),
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
        DropdownButtonFormField<PromoterSortByFilterState>(
          initialValue: _filterStates.sortByFilterState,
          decoration: InputDecoration(
            labelText: localization.promoter_overview_filter_sortby_choose,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: PromoterSortByFilterState.createdAt,
              child: Text(localization.promoter_overview_filter_sortby_date),
            ),
            DropdownMenuItem(
              value: PromoterSortByFilterState.firstName,
              child:
                  Text(localization.promoter_overview_filter_sortby_firstname),
            ),
            DropdownMenuItem(
              value: PromoterSortByFilterState.lastName,
              child:
                  Text(localization.promoter_overview_filter_sortby_lastname),
            ),
            DropdownMenuItem(
              value: PromoterSortByFilterState.email,
              child: Text(localization.promoter_overview_filter_sortby_email),
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
