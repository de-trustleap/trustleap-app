import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:flutter/material.dart';

class PagebuilderTextAlignmentControl extends StatefulWidget {
  final TextAlign initialAlignment;
  final Function(TextAlign) onSelected;
  final PagebuilderResponsiveBreakpoint currentBreakpoint;

  const PagebuilderTextAlignmentControl({
    super.key,
    required this.initialAlignment,
    required this.onSelected,
    required this.currentBreakpoint,
  });

  @override
  State<PagebuilderTextAlignmentControl> createState() =>
      _PagebuilderTextAlignmentControlState();
}

class _PagebuilderTextAlignmentControlState
    extends State<PagebuilderTextAlignmentControl> {
  late Set<TextAlign> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {widget.initialAlignment};
  }

  @override
  void didUpdateWidget(PagebuilderTextAlignmentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialAlignment != oldWidget.initialAlignment) {
      setState(() {
        _selected = {widget.initialAlignment};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(localization.landingpage_pagebuilder_text_config_alignment,
                style: themeData.textTheme.bodySmall),
            const SizedBox(width: 8),
            PagebuilderBreakpointSelector(
              currentBreakpoint: widget.currentBreakpoint,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SegmentedButton<TextAlign>(
            segments: [
              ButtonSegment<TextAlign>(
                  value: TextAlign.left,
                  tooltip: localization
                      .landingpage_pagebuilder_text_config_alignment_left,
                  icon: const Icon(Icons.format_align_left)),
              ButtonSegment<TextAlign>(
                  value: TextAlign.center,
                  tooltip: localization
                      .landingpage_pagebuilder_text_config_alignment_center,
                  icon: const Icon(Icons.format_align_center)),
              ButtonSegment<TextAlign>(
                  value: TextAlign.right,
                  tooltip: localization
                      .landingpage_pagebuilder_text_config_alignment_right,
                  icon: const Icon(Icons.format_align_right)),
              ButtonSegment<TextAlign>(
                  value: TextAlign.justify,
                  tooltip: localization
                      .landingpage_pagebuilder_text_config_alignment_justify,
                  icon: const Icon(Icons.format_align_justify)),
            ],
            showSelectedIcon: false,
            selected: _selected,
            onSelectionChanged: (Set<TextAlign> newSelectedValue) {
              setState(() {
                _selected = newSelectedValue;
                widget.onSelected(_selected.first);
              });
            }),
      ],
    );
  }
}
