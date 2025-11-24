import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderHierarchyHelper {
  final PageBuilderPage page;

  LandingPageBuilderHierarchyHelper({
    required this.page,
  });

  void onHierarchyItemSelected(String widgetId, bool isSection) {
    Modular.get<PagebuilderSelectionCubit>().selectWidget(widgetId);

    if (isSection) {
      final section = page.sections
          ?.where(
            (section) => section.id.value == widgetId,
          )
          .firstOrNull;
      if (section != null) {
        Modular.get<PagebuilderConfigMenuCubit>()
            .openSectionConfigMenu(section);
      }
    } else {
      final widget = findWidgetById(widgetId);
      if (widget != null) {
        Modular.get<PagebuilderConfigMenuCubit>().openConfigMenu(widget);
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

  PageBuilderWidget? _findWidgetInTree(
      PageBuilderWidget widget, String widgetId) {
    if (widget.id.value == widgetId) return widget;

    if (widget.children != null) {
      for (final child in widget.children!) {
        final found = _findWidgetInTree(child, widgetId);
        if (found != null) return found;
      }
    }

    if (widget.containerChild != null) {
      final found = _findWidgetInTree(widget.containerChild!, widgetId);
      if (found != null) return found;
    }

    return null;
  }

  Map<String, dynamic> getOptimalExpansionState(String targetWidgetId) {
    // For sections, we only need to expand that section
    // For widgets, we need to expand the section and all parent widgets in the path

    final sectionsToExpand = <String>[];
    final widgetsToExpand = <String>[];

    // Fast path: check if it's a section first
    for (final section in page.sections ?? []) {
      if (section.id.value == targetWidgetId) {
        sectionsToExpand.add(targetWidgetId);
        return {
          'sectionsToExpand': sectionsToExpand,
          'widgetsToExpand': widgetsToExpand,
          'sectionsToCollapse': <String>[],
          'widgetsToCollapse': <String>[],
        };
      }
    }

    // Find the widget and its path in one pass
    _TargetInfo? targetInfo;
    for (final section in page.sections ?? []) {
      final widgetPath = _findWidgetPathInSection(targetWidgetId, section);
      if (widgetPath.isNotEmpty || _widgetExistsAtRootLevel(targetWidgetId, section)) {
        sectionsToExpand.add(section.id.value);
        widgetsToExpand.addAll(widgetPath);
        targetInfo = _TargetInfo(
          sectionId: section.id.value,
          isSection: false,
          widgetPath: widgetPath,
        );
        break;
      }
    }

    if (targetInfo == null) {
      return {
        'sectionsToExpand': <String>[],
        'widgetsToExpand': <String>[],
        'sectionsToCollapse': <String>[],
        'widgetsToCollapse': <String>[],
      };
    }

    return {
      'sectionsToExpand': sectionsToExpand,
      'widgetsToExpand': widgetsToExpand,
      'sectionsToCollapse': <String>[],
      'widgetsToCollapse': <String>[],
    };
  }

  bool _widgetExistsAtRootLevel(String targetWidgetId, PageBuilderSection section) {
    final widgets = section.widgets ?? [];
    for (final widget in widgets) {
      if (widget.id.value == targetWidgetId) {
        return true;
      }
    }
    return false;
  }

  Map<String, List<String>> getExpansionPathForWidget(String targetWidgetId) {
    final targetInfo = _findTargetLocation(targetWidgetId);
    return {
      'sections': targetInfo != null ? [targetInfo.sectionId] : <String>[],
      'widgets': targetInfo?.widgetPath ?? <String>[],
    };
  }

  _TargetInfo? _findTargetLocation(String targetWidgetId) {
    for (final section in page.sections ?? []) {
      if (section.id.value == targetWidgetId) {
        return _TargetInfo(
          sectionId: section.id.value,
          isSection: true,
          widgetPath: [],
        );
      }
    }

    for (final section in page.sections ?? []) {
      if (_widgetExistsInSection(targetWidgetId, section)) {
        final widgetPath = _findWidgetPathInSection(targetWidgetId, section);
        return _TargetInfo(
          sectionId: section.id.value,
          isSection: false,
          widgetPath: widgetPath,
        );
      }
    }

    return null;
  }

  List<String> _findWidgetPathInSection(
      String targetWidgetId, PageBuilderSection section) {
    final widgets = section.widgets ?? [];

    for (final widget in widgets) {
      if (widget.id.value == targetWidgetId) {
        return [];
      }

      final path = _findWidgetPathInWidget(targetWidgetId, widget, []);
      if (path.isNotEmpty) {
        return path;
      }
    }

    return [];
  }

  List<String> _findWidgetPathInWidget(String targetWidgetId,
      PageBuilderWidget widget, List<String> currentPath) {
    if (widget.id.value == targetWidgetId) {
      return currentPath;
    }

    final newPath = [...currentPath, widget.id.value];

    if (widget.children != null) {
      for (final child in widget.children!) {
        final path = _findWidgetPathInWidget(targetWidgetId, child, newPath);
        if (path.isNotEmpty) {
          return path;
        }
      }
    }

    if (widget.containerChild != null) {
      final path = _findWidgetPathInWidget(
          targetWidgetId, widget.containerChild!, newPath);
      if (path.isNotEmpty) {
        return path;
      }
    }

    return [];
  }

  bool _widgetExistsInSection(
      String targetWidgetId, PageBuilderSection section) {
    final widgets = section.widgets ?? [];

    for (final widget in widgets) {
      if (_widgetExistsInWidgetTree(targetWidgetId, widget)) {
        return true;
      }
    }

    return false;
  }

  bool _widgetExistsInWidgetTree(
      String targetWidgetId, PageBuilderWidget widget) {
    if (widget.id.value == targetWidgetId) {
      return true;
    }

    if (widget.children != null) {
      for (final child in widget.children!) {
        if (_widgetExistsInWidgetTree(targetWidgetId, child)) {
          return true;
        }
      }
    }

    if (widget.containerChild != null) {
      if (_widgetExistsInWidgetTree(targetWidgetId, widget.containerChild!)) {
        return true;
      }
    }

    return false;
  }

}

class _TargetInfo {
  final String sectionId;
  final bool isSection;
  final List<String> widgetPath;

  _TargetInfo({
    required this.sectionId,
    required this.isSection,
    required this.widgetPath,
  });
}
