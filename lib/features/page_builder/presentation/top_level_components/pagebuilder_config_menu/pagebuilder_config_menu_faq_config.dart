import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuFaqConfig extends StatelessWidget {
  final PageBuilderWidget model;

  const PagebuilderConfigMenuFaqConfig({super.key, required this.model});

  PageBuilderFaqProperties get _props =>
      model.properties as PageBuilderFaqProperties;

  void _update(PageBuilderFaqProperties updated, PagebuilderBloc bloc) {
    bloc.add(UpdateWidgetEvent(model.copyWith(properties: updated)));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final bloc = Modular.get<PagebuilderBloc>();

    if (model.elementType != PageBuilderWidgetType.faq ||
        model.properties is! PageBuilderFaqProperties) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CollapsibleTile(
          title: localization.pagebuilder_faq_config_question_style_title,
          children: [
            PagebuilderConfigMenuTextConfig(
              properties: _props.questionTextProperties,
              showHoverTabBar: false,
              onChanged: (props) =>
                  _update(_props.copyWith(questionTextProperties: props), bloc),
              onChangedHover: (_) {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        CollapsibleTile(
          title: localization.pagebuilder_faq_config_answer_style_title,
          children: [
            PagebuilderConfigMenuTextConfig(
              properties: _props.answerTextProperties,
              showHoverTabBar: false,
              onChanged: (props) =>
                  _update(_props.copyWith(answerTextProperties: props), bloc),
              onChangedHover: (_) {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        CollapsibleTile(
          title: localization.pagebuilder_faq_config_indicator_color_title,
          children: [
            PagebuilderColorControl(
              title: localization.pagebuilder_faq_config_indicator_color_title,
              initialColor: _props.chevronColor ?? Colors.black,
              enableGradients: false,
              onColorSelected: (color, {token}) =>
                  _update(_props.copyWith(chevronColor: color), bloc),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CollapsibleTile(
          title: localization.pagebuilder_faq_config_question_background_title,
          children: [
            PagebuilderColorControl(
              title: localization.pagebuilder_faq_config_question_background_title,
              initialColor:
                  _props.questionBackgroundPaint?.color ?? Colors.transparent,
              initialGradient: _props.questionBackgroundPaint?.gradient,
              enableGradients: true,
              onColorSelected: (color, {token}) => _update(
                _props.copyWith(
                    questionBackgroundPaint:
                        PagebuilderPaint.color(color, globalColorToken: token)),
                bloc,
              ),
              onGradientSelected: (gradient) => _update(
                _props.copyWith(
                    questionBackgroundPaint: PagebuilderPaint.gradient(gradient)),
                bloc,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CollapsibleTile(
          title: localization.pagebuilder_faq_config_answer_background_title,
          children: [
            PagebuilderColorControl(
              title: localization.pagebuilder_faq_config_answer_background_title,
              initialColor:
                  _props.answerBackgroundPaint?.color ?? Colors.transparent,
              initialGradient: _props.answerBackgroundPaint?.gradient,
              enableGradients: true,
              onColorSelected: (color, {token}) => _update(
                _props.copyWith(
                    answerBackgroundPaint:
                        PagebuilderPaint.color(color, globalColorToken: token)),
                bloc,
              ),
              onGradientSelected: (gradient) => _update(
                _props.copyWith(
                    answerBackgroundPaint: PagebuilderPaint.gradient(gradient)),
                bloc,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CollapsibleTile(
          title: localization.pagebuilder_faq_config_border_color_title,
          children: [
            PagebuilderColorControl(
              title: localization.pagebuilder_faq_config_border_color_title,
              initialColor: _props.borderPaint?.color ?? Colors.transparent,
              enableGradients: false,
              onColorSelected: (color, {token}) => _update(
                _props.copyWith(
                    borderPaint:
                        PagebuilderPaint.color(color, globalColorToken: token)),
                bloc,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
