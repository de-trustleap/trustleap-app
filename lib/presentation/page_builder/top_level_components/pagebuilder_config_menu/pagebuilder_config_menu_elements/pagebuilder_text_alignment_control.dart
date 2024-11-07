import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PagebuilderTextAlignmentControl extends StatefulWidget {
  final TextAlign initialAlignment;
  final Function(TextAlign) onSelected;

  const PagebuilderTextAlignmentControl(
      {super.key, required this.initialAlignment, required this.onSelected});

  @override
  State<PagebuilderTextAlignmentControl> createState() =>
      _PagebuilderTextAlignmentControlState();
}

class _PagebuilderTextAlignmentControlState
    extends State<PagebuilderTextAlignmentControl> {
  late Set<TextAlign> selected;

  @override
  void initState() {
    super.initState();
    selected = {widget.initialAlignment};
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(localization.landingpage_pagebuilder_text_config_alignment,
            style: themeData.textTheme.bodySmall),
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
            selected: selected,
            onSelectionChanged: (Set<TextAlign> newSelectedValue) {
              setState(() {
                selected = newSelectedValue;
                widget.onSelected(selected.first);
              });
            }),
      ],
    );
  }
}
