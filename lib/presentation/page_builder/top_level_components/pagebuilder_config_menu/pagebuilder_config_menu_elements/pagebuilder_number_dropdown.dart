import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:flutter/material.dart';

class PagebuilderNumberDropdown extends StatelessWidget {
  final String title;
  final double initialValue;
  final List<double> numbers;
  final Function(double) onSelected;
  final PagebuilderResponsiveBreakpoint? currentBreakpoint;
  final ValueChanged<PagebuilderResponsiveBreakpoint>? onBreakpointChanged;

  const PagebuilderNumberDropdown({
    super.key,
    required this.title,
    required this.initialValue,
    required this.numbers,
    required this.onSelected,
    this.currentBreakpoint,
    this.onBreakpointChanged,
  });

  List<DropdownMenuEntry<double>> createDropdownEntries() {
    List<DropdownMenuEntry<double>> entries = [];
    for (var number in numbers) {
      var entry = DropdownMenuEntry<double>(value: number, label: "$number");
      entries.add(entry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(children: [
      Text(title, style: themeData.textTheme.bodySmall),
      if (currentBreakpoint != null && onBreakpointChanged != null) ...[
        const SizedBox(width: 8),
        PagebuilderBreakpointSelector(
          currentBreakpoint: currentBreakpoint!,
          onBreakpointChanged: onBreakpointChanged!,
        ),
      ],
      const Spacer(),
      DropdownMenu<double>(
        width: 100,
        initialSelection: initialValue,
        enableSearch: false,
        requestFocusOnTap: false,
        dropdownMenuEntries: createDropdownEntries(),
        onSelected: (number) {
          onSelected(number ?? 0.0);
        },
        menuStyle: MenuStyle(
          elevation: WidgetStateProperty.all(4),
          fixedSize: WidgetStateProperty.all(const Size(100, 200)),
          alignment: AlignmentDirectional.topStart,
        ),
      ),
    ]);
  }
}
