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

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? HtmlEditorController();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      height: 350,
      decoration: BoxDecoration(
        border: Border.all(color: themeData.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: HtmlEditor(
        controller: controller,
        htmlEditorOptions: HtmlEditorOptions(
          hint: "Text eingeben...",
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
              clearAll: false,
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
          height: 300,
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.disable();
    super.dispose();
  }
}
