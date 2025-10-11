import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:highlight/languages/css.dart';

class PagebuilderConfigMenuCustomCSS extends StatefulWidget {
  final PageBuilderWidget? model;
  final PageBuilderSection? section;
  const PagebuilderConfigMenuCustomCSS(
      {super.key, required this.model, required this.section});

  @override
  State<PagebuilderConfigMenuCustomCSS> createState() =>
      _PagebuilderConfigMenuCustomCSSState();
}

class _PagebuilderConfigMenuCustomCSSState
    extends State<PagebuilderConfigMenuCustomCSS> {
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    final isWidget = widget.model != null;
    _codeController = CodeController(
      text: isWidget ? (widget.model?.customCSS ?? '') : (widget.section?.customCSS ?? ''),
      language: css,
    );

    _codeController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final isWidget = widget.model != null;

    if (isWidget) {
      final updatedWidget = widget.model!.copyWith(
        customCSS: _codeController.text.isEmpty ? null : _codeController.text,
      );
      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
    } else {
      final updatedSection = widget.section!.copyWith(
        customCSS: _codeController.text.isEmpty ? null : _codeController.text,
      );
      pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return CollapsibleTile(
      title: localization.landingpage_pagebuilder_custom_css_menu_title,
      children: [
        Text(localization.landingpage_pagebuilder_custom_css_menu_description,
            style: themeData.textTheme.bodySmall),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: themeData.dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CodeTheme(
            data: CodeThemeData(styles: monokaiSublimeTheme),
            child: CodeField(
              controller: _codeController,
              textStyle: const TextStyle(
                fontFamily: "monospace",
                fontSize: 14,
              ),
              expands: true,
            ),
          ),
        ),
      ],
    );
  }
}
