import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_image_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuBackground extends StatelessWidget {
  final PageBuilderWidget? model;
  final PageBuilderSection? section;
  const PagebuilderConfigMenuBackground(
      {super.key, required this.model, required this.section});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    final isWidget = model != null;

    return CollapsibleTile(
        title: localization.landingpage_pagebuilder_layout_menu_background,
        children: [
          if (isWidget)
            PagebuilderHoverConfigTabBar<PagebuilderBackground>(
              properties: model?.background ??
                  const PagebuilderBackground(
                      backgroundPaint: null,
                      imageProperties: null,
                      overlayPaint: null),
              hoverProperties: model?.hoverBackground,
              hoverEnabled: model?.hoverBackground != null,
              onHoverEnabledChanged: (enabled) {
                if (enabled) {
                  final hoverBackground = (model?.background ??
                          const PagebuilderBackground(
                              backgroundPaint: null,
                              imageProperties: null,
                              overlayPaint: null))
                      .deepCopy();
                  final updatedWidget =
                      model!.copyWith(hoverBackground: hoverBackground);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else {
                  final updatedWidget =
                      model!.copyWith(removeHoverBackground: true);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }
              },
              onChanged: (updated, isHover) {
                if (isHover) {
                  final updatedWidget =
                      model!.copyWith(hoverBackground: updated);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else {
                  final updatedWidget = model!.copyWith(background: updated);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }
              },
              configBuilder: (props, disabled, onChangedLocal) =>
                  _buildBackgroundConfigUI(props, disabled, localization,
                      onChangedLocal, isWidget, pagebuilderBloc),
            )
          else
            _buildBackgroundConfigUI(
                section?.background ??
                    const PagebuilderBackground(
                        backgroundPaint: null,
                        imageProperties: null,
                        overlayPaint: null),
                false,
                localization,
                (updated) => _updateSectionBackground(updated, pagebuilderBloc),
                isWidget,
                pagebuilderBloc),
        ]);
  }

  Widget _buildBackgroundConfigUI(
      PagebuilderBackground? props,
      bool disabled,
      AppLocalizations localization,
      Function(PagebuilderBackground?) onChangedLocal,
      bool isWidget,
      PagebuilderBloc pagebuilderBloc) {
    if (disabled) {
      return const SizedBox.shrink();
    }

    return Column(children: [
      PagebuilderColorControl(
          title:
              localization.landingpage_pagebuilder_layout_menu_background_color,
          initialColor: props?.backgroundPaint?.color ?? Colors.transparent,
          initialGradient: props?.backgroundPaint?.gradient,
          onColorSelected: (color) {
            final paint = PagebuilderPaint.color(color);
            onChangedLocal(props?.copyWith(backgroundPaint: paint) ??
                const PagebuilderBackground(
                        backgroundPaint: null,
                        imageProperties: null,
                        overlayPaint: null)
                    .copyWith(backgroundPaint: paint));
          },
          onGradientSelected: (gradient) {
            final paint = PagebuilderPaint.gradient(gradient);
            onChangedLocal(props?.copyWith(backgroundPaint: paint) ??
                const PagebuilderBackground(
                        backgroundPaint: null,
                        imageProperties: null,
                        overlayPaint: null)
                    .copyWith(backgroundPaint: paint));
          }),
      const SizedBox(height: 20),
      PagebuilderImageControl(
          properties: props?.imageProperties ??
              const PageBuilderImageProperties(
                  url: null,
                  border: null,
                  width: null,
                  height: null,
                  contentMode: null,
                  showPromoterImage: null,
                  overlayPaint: null),
          widgetModel: isWidget ? model : null,
          showPromoterSwitch: false,
          onSelected: (properties) {
            onChangedLocal(props?.copyWith(imageProperties: properties) ??
                const PagebuilderBackground(
                        backgroundPaint: null,
                        imageProperties: null,
                        overlayPaint: null)
                    .copyWith(imageProperties: properties));
          },
          onDelete: () {
            if (props?.imageProperties != null) {
              onChangedLocal(props!.copyWith(setImagePropertiesNull: true));
            }
          }),
      if (props?.imageProperties != null) ...[
        const SizedBox(height: 20),
        BlocBuilder<PagebuilderResponsiveBreakpointCubit,
            PagebuilderResponsiveBreakpoint>(
          bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
          builder: (context, currentBreakpoint) {
            final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);
            return PagebuilderConfigMenuDrowdown(
                title: localization
                    .landingpage_pagebuilder_layout_menu_background_contentmode,
                initialValue:
                    helper.getValue(props?.imageProperties?.contentMode) ??
                        BoxFit.cover,
                type: PagebuilderDropdownType.contentMode,
                showResponsiveButton: true,
                currentBreakpoint: currentBreakpoint,
                onSelected: (contentMode) {
                  final updatedContentMode = helper.setValue(
                      props?.imageProperties?.contentMode, contentMode);
                  final updatedImageProperties = props!.imageProperties!
                      .copyWith(contentMode: updatedContentMode);
                  onChangedLocal(
                      props.copyWith(imageProperties: updatedImageProperties));
                });
          },
        ),
        const SizedBox(height: 20),
        PagebuilderColorControl(
            title: localization
                .landingpage_pagebuilder_layout_menu_background_overlay,
            initialColor: props?.overlayPaint?.color ?? Colors.transparent,
            initialGradient: props?.overlayPaint?.gradient,
            onColorSelected: (color) {
              final paint = PagebuilderPaint.color(color);
              onChangedLocal(props?.copyWith(overlayPaint: paint) ??
                  const PagebuilderBackground(
                          backgroundPaint: null,
                          imageProperties: null,
                          overlayPaint: null)
                      .copyWith(overlayPaint: paint));
            },
            onGradientSelected: (gradient) {
              final paint = PagebuilderPaint.gradient(gradient);
              onChangedLocal(props?.copyWith(overlayPaint: paint) ??
                  const PagebuilderBackground(
                          backgroundPaint: null,
                          imageProperties: null,
                          overlayPaint: null)
                      .copyWith(overlayPaint: paint));
            }),
      ]
    ]);
  }

  void _updateSectionBackground(
      PagebuilderBackground? updated, PagebuilderBloc pagebuilderBloc) {
    if (section != null) {
      final updatedSection = section!.copyWith(background: updated);
      pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
    }
  }
}
