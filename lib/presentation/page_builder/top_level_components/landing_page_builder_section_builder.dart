import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_section_edit_button.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderSectionView extends StatefulWidget {
  final PageBuilderSection model;

  const LandingPageBuilderSectionView({super.key, required this.model});

  @override
  State<LandingPageBuilderSectionView> createState() =>
      _LandingPageBuilderSectionViewState();
}

class _LandingPageBuilderSectionViewState
    extends State<LandingPageBuilderSectionView> {
  final LandingPageBuilderWidgetBuilder widgetBuilder =
      LandingPageBuilderWidgetBuilder();
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    switch (widget.model.layout) {
      case PageBuilderSectionLayout.column:
      default:
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: widget.model.maxWidth ?? double.infinity),
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHovered = false;
              });
            },
            child: BlocBuilder<PagebuilderSelectionCubit, String?>(
              builder: (context, selectedSectionId) {
                final isSelected = selectedSectionId == widget.model.id.value;
                final showBorder = _isHovered || isSelected;
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: widget.model.background?.backgroundColor,
                          border: showBorder
                              ? Border.all(
                                  color: isSelected
                                      ? themeData.colorScheme.secondary
                                      : themeData.colorScheme.primary,
                                  width: 2.0,
                                )
                              : null,
                        ),
                        child: Stack(
                          children: [
                            if (widget.model.background?.imageProperties
                                        ?.localImage ==
                                    null &&
                                widget.model.background?.imageProperties?.url !=
                                    null) ...[
                              Positioned.fill(
                                child: Image.network(
                                    widget.model.background!.imageProperties!
                                        .url!,
                                    fit: widget.model.background
                                            ?.imageProperties?.contentMode ??
                                        BoxFit.cover),
                              )
                            ],
                            if (widget.model.background?.imageProperties
                                    ?.localImage !=
                                null)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: widget.model.background!
                                              .imageProperties!.contentMode ??
                                          BoxFit.cover,
                                      image: MemoryImage(widget
                                          .model
                                          .background!
                                          .imageProperties!
                                          .localImage!),
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.model.background?.overlayColor != null &&
                                (widget.model.background?.imageProperties
                                            ?.localImage !=
                                        null ||
                                    widget.model.background?.imageProperties
                                            ?.url !=
                                        null)) ...[
                              Positioned.fill(
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: widget
                                              .model.background!.overlayColor)))
                            ],
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                  children: widget.model.widgets != null
                                      ? widget.model.widgets!
                                          .map((widget) =>
                                              widgetBuilder.build(widget))
                                          .toList()
                                      : []),
                            )
                          ],
                        )),
                    if (_isHovered) ...[
                      LandingPageBuilderSectionEditButton(onPressed: () {
                        BlocProvider.of<PagebuilderSelectionCubit>(context)
                            .selectWidget(widget.model.id.value);
                        Modular.get<PagebuilderConfigMenuCubit>()
                            .openSectionConfigMenu(widget.model);
                      })
                    ]
                  ],
                );
              },
            ),
          ),
        );
    }
  }
}
