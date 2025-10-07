import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuSectionVisibleOn extends StatelessWidget {
  final PageBuilderSection section;

  const PagebuilderConfigMenuSectionVisibleOn({
    super.key,
    required this.section,
  });

  bool _isBreakpointVisible(PagebuilderResponsiveBreakpoint breakpoint) {
    // If visibleOn is null, it's visible on all breakpoints
    if (section.visibleOn == null) {
      return true;
    }
    return section.visibleOn!.contains(breakpoint);
  }

  void _toggleBreakpoint(
      PagebuilderResponsiveBreakpoint breakpoint, bool? value) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();

    // Get current list or create from all values if null
    List<PagebuilderResponsiveBreakpoint> currentList;
    if (section.visibleOn == null) {
      currentList = List.from(PagebuilderResponsiveBreakpoint.values);
    } else {
      currentList = List.from(section.visibleOn!);
    }

    // Toggle the breakpoint
    if (value == true) {
      if (!currentList.contains(breakpoint)) {
        currentList.add(breakpoint);
      }
    } else {
      currentList.remove(breakpoint);
    }

    // If all breakpoints are selected, set to null (visible on all)
    List<PagebuilderResponsiveBreakpoint>? newVisibleOn;
    bool shouldUpdate = false;

    if (currentList.length == PagebuilderResponsiveBreakpoint.values.length) {
      newVisibleOn = null;
      shouldUpdate = true;
    } else {
      newVisibleOn = currentList;
      shouldUpdate = true;
    }

    final updatedSection = section.copyWith(
      visibleOn: newVisibleOn,
      updateVisibleOn: shouldUpdate,
    );
    pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.pagebuilder_section_visible_on_title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          CheckboxListTile(
            title: Text(
              localization.pagebuilder_section_visible_on_desktop,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value:
                _isBreakpointVisible(PagebuilderResponsiveBreakpoint.desktop),
            onChanged: (value) => _toggleBreakpoint(
                PagebuilderResponsiveBreakpoint.desktop, value),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: Text(
              localization.pagebuilder_section_visible_on_tablet,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: _isBreakpointVisible(PagebuilderResponsiveBreakpoint.tablet),
            onChanged: (value) => _toggleBreakpoint(
                PagebuilderResponsiveBreakpoint.tablet, value),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: Text(
              localization.pagebuilder_section_visible_on_mobile,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: _isBreakpointVisible(PagebuilderResponsiveBreakpoint.mobile),
            onChanged: (value) => _toggleBreakpoint(
                PagebuilderResponsiveBreakpoint.mobile, value),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }
}
