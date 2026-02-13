import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_section_name_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagebuilderConfigMenuSectionName extends StatefulWidget {
  final String? sectionName;
  final Function(String)? onChanged;
  final List<String>? existingSectionNames;

  const PagebuilderConfigMenuSectionName({
    super.key,
    required this.sectionName,
    this.onChanged,
    this.existingSectionNames,
  });

  @override
  State<PagebuilderConfigMenuSectionName> createState() =>
      _PagebuilderConfigMenuSectionNameState();
}

class _PagebuilderConfigMenuSectionNameState
    extends State<PagebuilderConfigMenuSectionName> {
  late TextEditingController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.sectionName);
  }

  @override
  void didUpdateWidget(PagebuilderConfigMenuSectionName oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.sectionName) {
      _controller.text = widget.sectionName ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final currentValue = _controller.text;
    final validationError = PagebuilderSectionNameValidator.validate(
      currentValue,
      AppLocalizations.of(context),
      existingSectionNames: widget.existingSectionNames,
      currentSectionName: widget.sectionName,
    );

    if (validationError == null) {
      widget.onChanged?.call(currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FormTextfield(
                controller: _controller,
                placeholder: localization.pagebuilder_section_id_placeholder,
                disabled: false,
                validator: (value) => PagebuilderSectionNameValidator.validate(
                  value,
                  localization,
                  existingSectionNames: widget.existingSectionNames,
                  currentSectionName: widget.sectionName,
                ),
                onChanged: () => _handleTextChange(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _controller.text));
              },
              icon: const Icon(Icons.copy),
              iconSize: 20,
              padding: const EdgeInsets.all(4),
              tooltip: localization.pagebuilder_section_copy_id_tooltip,
              color: themeData.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
