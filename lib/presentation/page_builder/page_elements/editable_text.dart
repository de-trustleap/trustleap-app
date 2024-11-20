// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageBuilderEditableText extends StatefulWidget {
  final PageBuilderTextProperties properties;
  final PageBuilderWidget widgetModel;

  const PageBuilderEditableText({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  @override
  State<PageBuilderEditableText> createState() =>
      _PageBuilderEditableTextViewState();
}

class _PageBuilderEditableTextViewState extends State<PageBuilderEditableText> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final TextStyleParser parser = TextStyleParser();

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
  void didUpdateWidget(covariant PageBuilderEditableText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.properties.text != widget.properties.text) {
      _controller.text = widget.properties.text ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LandingPageBuilderWidgetContainer(
      model: widget.widgetModel,
      child: GestureDetector(
        onTap: () {
          if (!_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
        },
        child: Container(
          width: double.infinity,
          decoration: _focusNode.hasFocus
              ? BoxDecoration(
                  color: widget.widgetModel.backgroundColor,
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8)))
              : BoxDecoration(color: widget.widgetModel.backgroundColor),
          child: TextField(
              controller: _controller,
              textAlign: widget.properties.alignment ?? TextAlign.left,
              focusNode: _focusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: parser.getTextStyleFromProperties(widget.properties),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
              ),
              onChanged: (newText) {
                final updatedProperties =
                    widget.properties.copyWith(text: newText);
                final updatedWidget =
                    widget.widgetModel.copyWith(properties: updatedProperties);
                Modular.get<PagebuilderBloc>()
                    .add(UpdateWidgetEvent(updatedWidget));
              }),
        ),
      ),
    );
  }
}
