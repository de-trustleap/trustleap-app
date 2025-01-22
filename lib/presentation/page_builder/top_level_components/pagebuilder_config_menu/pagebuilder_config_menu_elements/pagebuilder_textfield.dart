import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:flutter/material.dart';

class PagebuilderTextField extends StatefulWidget {
  final String? initialText;
  final int minLines;
  final int maxLines;
  final String? placeholder;
  final Function(String) onChanged;
  const PagebuilderTextField(
      {super.key,
      required this.initialText,
      required this.onChanged,
      this.placeholder,
      this.minLines = 1,
      this.maxLines = 1});

  @override
  State<PagebuilderTextField> createState() => _PagebuilderTextFieldState();
}

class _PagebuilderTextFieldState extends State<PagebuilderTextField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return FormTextfield(
      controller: _controller,
      disabled: false,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      placeholder: widget.placeholder ??
          localization.landingpage_pagebuilder_text_config_text_placeholder,
      desktopStyle: themeData.textTheme.bodySmall,
      onChanged: () => widget.onChanged(_controller.text),
    );
  }
}
