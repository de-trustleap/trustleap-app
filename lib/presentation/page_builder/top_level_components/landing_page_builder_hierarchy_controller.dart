import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderHierarchyController {
  final PageBuilderPage page;
  final PagebuilderConfigMenuCubit configMenuCubit;
  final BuildContext context;

  LandingPageBuilderHierarchyController({
    required this.page,
    required this.configMenuCubit,
    required this.context,
  });

  void onHierarchyItemSelected(String widgetId, bool isSection) {
    // Update selection
    BlocProvider.of<PagebuilderSelectionCubit>(context).selectWidget(widgetId);
    
    // Open appropriate config menu
    if (isSection) {
      final section = page.sections?.firstWhere(
        (section) => section.id.value == widgetId,
        orElse: () => throw Exception('Section not found'),
      );
      if (section != null) {
        configMenuCubit.openSectionConfigMenu(section);
      }
    } else {
      final widget = findWidgetById(widgetId);
      if (widget != null) {
        configMenuCubit.openConfigMenu(widget);
      }
    }
  }

  PageBuilderWidget? findWidgetById(String widgetId) {
    for (final section in page.sections ?? []) {
      for (final widget in section.widgets ?? []) {
        final found = _findWidgetInTree(widget, widgetId);
        if (found != null) return found;
      }
    }
    return null;
  }

  PageBuilderWidget? _findWidgetInTree(PageBuilderWidget widget, String widgetId) {
    if (widget.id.value == widgetId) return widget;
    
    // Check children
    if (widget.children != null) {
      for (final child in widget.children!) {
        final found = _findWidgetInTree(child, widgetId);
        if (found != null) return found;
      }
    }
    
    // Check container child
    if (widget.containerChild != null) {
      final found = _findWidgetInTree(widget.containerChild!, widgetId);
      if (found != null) return found;
    }
    
    return null;
  }
}