import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';

class PagebuilderReorderSectionHelper {
  static List<PageBuilderSection> reorderSections(
      List<PageBuilderSection> sections, int oldIndex, int newIndex) {
    final updatedSections = List<PageBuilderSection>.from(sections);
    final item = updatedSections.removeAt(oldIndex);
    final insertIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    updatedSections.insert(insertIndex, item);
    return updatedSections;
  }
}
