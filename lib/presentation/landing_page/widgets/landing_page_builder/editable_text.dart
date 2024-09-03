// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

class PageBuilderEditableText extends StatefulWidget {
  final PageBuilderTextProperties properties;
  final Function(String) onTextChanged;

  const PageBuilderEditableText({
    super.key,
    required this.properties,
    required this.onTextChanged,
  });

  @override
  State<PageBuilderEditableText> createState() =>
      _PageBuilderEditableTextViewState();
}

class _PageBuilderEditableTextViewState extends State<PageBuilderEditableText> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.properties.text ?? "");
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {}); // Aktualisiert die UI, wenn sich der Fokus ändert
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_focusNode.hasFocus) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: _focusNode.hasFocus
            ? BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(8)))
            : null,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              widget.properties.padding?.left ?? 0,
              widget.properties.padding?.top ?? 0,
              widget.properties.padding?.right ?? 0,
              widget.properties.padding?.bottom ?? 0),
          child: TextField(
              controller: _controller,
              textAlign: widget.properties.alignment ?? TextAlign.left,
              focusNode: _focusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                  fontSize: widget.properties.fontSize,
                  color: widget.properties.color),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
              ),
              onChanged: (newText) => widget.onTextChanged(newText)),
        ),
      ),
    );
  }
}
