import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuAnchorButtonContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuAnchorButtonContent(
      {super.key, required this.model});

  void updateTextProperties(PagebuilderAnchorButtonProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();

    if (model.elementType == PageBuilderWidgetType.anchorButton &&
        model.properties is PagebuilderAnchorButtonProperties) {
      // TODO: IMPLEMENT
    } else {
      return const SizedBox.shrink();
    }
  }
}
