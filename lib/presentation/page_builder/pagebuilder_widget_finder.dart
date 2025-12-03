import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/helpers/pagebuilder_widget_tree_searcher.dart';

class PagebuilderWidgetFinder {
  PageBuilderSection? findSectionById(
      PageBuilderPage page, UniqueID sectionId) {
    for (var section in page.sections ?? []) {
      if (section.id == sectionId) {
        return section;
      }
    }
    return null;
  }

  PageBuilderWidget? findWidgetById(PageBuilderPage page, UniqueID widgetId) {
    for (var section in page.sections ?? []) {
      for (var widget in section.widgets ?? []) {
        final found = PagebuilderWidgetTreeSearcher.findWidgetById(
          widget,
          widgetId.value,
        );
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }
}
