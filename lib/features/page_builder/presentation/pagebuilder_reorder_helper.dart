import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';

class PagebuilderReorderHelper {
  static List<T> reorder<T>(List<T> items, int oldIndex, int newIndex) {
    final updatedItems = List<T>.from(items);
    final item = updatedItems.removeAt(oldIndex);
    final insertIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    updatedItems.insert(insertIndex, item);
    return updatedItems;
  }

  static List<PageBuilderSection> reorderSections(
      List<PageBuilderSection> sections, int oldIndex, int newIndex) {
    return reorder<PageBuilderSection>(sections, oldIndex, newIndex);
  }

  static List<PageBuilderWidget> reorderWidgets(
      List<PageBuilderWidget> widgets, int oldIndex, int newIndex) {
    return reorder<PageBuilderWidget>(widgets, oldIndex, newIndex);
  }
}
