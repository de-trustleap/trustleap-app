import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_faq_items_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuFaqContent extends StatelessWidget {
  final PageBuilderWidget model;

  const PagebuilderConfigMenuFaqContent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final bloc = Modular.get<PagebuilderBloc>();

    if (model.elementType != PageBuilderWidgetType.faq ||
        model.properties is! PageBuilderFaqProperties) {
      return const SizedBox.shrink();
    }

    return PagebuilderConfigMenuFaqItemsEditor(
      model: model,
      bloc: bloc,
      localization: localization,
    );
  }
}
