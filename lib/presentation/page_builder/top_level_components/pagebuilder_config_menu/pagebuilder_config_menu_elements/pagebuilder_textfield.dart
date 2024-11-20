import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:flutter/material.dart';

class PagebuilderTextField extends StatefulWidget {
  final PageBuilderWidget model;
  final Function(String) onChanged;
  const PagebuilderTextField(
      {super.key, required this.model, required this.onChanged});

  @override
  State<PagebuilderTextField> createState() => _PagebuilderTextFieldState();
}

class _PagebuilderTextFieldState extends State<PagebuilderTextField> {
  @override
  void initState() {
    super.initState();
    _controller.text =
        (widget.model.properties as PageBuilderTextProperties).text ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return FormTextfield(
      controller: _controller,
      disabled: false,
      minLines: 5,
      maxLines: 10,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      placeholder:
          localization.landingpage_pagebuilder_text_config_text_placeholder,
      desktopStyle: themeData.textTheme.bodySmall,
      onChanged: () => widget.onChanged(_controller.text),
    );
  }
}
