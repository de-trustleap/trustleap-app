import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker_base.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class PagebuilderHTMLTextEditor extends StatefulWidget {
  final String? initialHtml;
  final Function(String) onChanged;
  final HtmlEditorController? controller;
  final Function(String)? onInsertPlaceholder;

  const PagebuilderHTMLTextEditor({
    super.key,
    this.initialHtml,
    required this.onChanged,
    this.controller,
    this.onInsertPlaceholder,
  });

  @override
  State<PagebuilderHTMLTextEditor> createState() =>
      _PagebuilderHTMLTextEditorState();
}

class _PagebuilderHTMLTextEditorState extends State<PagebuilderHTMLTextEditor> {
  late final HtmlEditorController controller;
  Color _currentTextColor = Colors.black;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? HtmlEditorController();
  }

  void _applyTextColor(Color color) {
    setState(() {
      _currentTextColor = color;
    });

    final r = (color.r * 255.0).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255.0).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255.0).round().toRadixString(16).padLeft(2, '0');
    final hexColor = '#$r$g$b';

    controller.execCommand('foreColor', argument: hexColor);
  }

  void _onSelectionChanged(EditorSettings settings) {
    if (mounted) {
      setState(() {
        _currentTextColor = settings.foregroundColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      height: 350,
      decoration: BoxDecoration(
        border: Border.all(color: themeData.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: themeData.colorScheme.outline),
              ),
            ),
            child: Row(
              children: [
                PagebuilderColorPickerBase(
                  initialColor: _currentTextColor,
                  onColorSelected: _applyTextColor,
                  enableOpacity: false,
                  enableGradients: false,
                ),
                const SizedBox(width: 8),
                Text(
                  localization.pagebuilder_html_text_editor_select_color,
                  style: themeData.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: HtmlEditor(
              controller: controller,
              htmlEditorOptions: HtmlEditorOptions(
                hint: localization.pagebuilder_html_text_editor_hint,
                initialText: widget.initialHtml ?? "",
                shouldEnsureVisible: true,
                adjustHeightForKeyboard: true,
              ),
              htmlToolbarOptions: const HtmlToolbarOptions(
                defaultToolbarButtons: [
                  FontButtons(
                    bold: true,
                    italic: true,
                    underline: true,
                    strikethrough: true,
                    superscript: true,
                    subscript: true,
                    clearAll: true,
                  ),
                  ListButtons(
                    ul: true,
                    ol: true,
                    listStyles: false,
                  ),
                ],
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeScrollable,
              ),
              otherOptions: OtherOptions(
                height: 250,
                decoration: BoxDecoration(
                  color: themeData.colorScheme.surface,
                ),
              ),
              callbacks: Callbacks(
                onChangeContent: (String? changed) {
                  if (changed != null) {
                    widget.onChanged(changed);
                  }
                },
                onChangeSelection: _onSelectionChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.disable();
    super.dispose();
  }
}
