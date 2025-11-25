import 'package:bloc/bloc.dart';

class PagebuilderHierarchyExpansionCubit
    extends Cubit<PagebuilderHierarchyExpansionState> {
  PagebuilderHierarchyExpansionCubit()
      : super(const PagebuilderHierarchyExpansionState());

  void toggleSection(String sectionId) {
    final newExpandedSections = Set<String>.from(state.expandedSections);
    if (newExpandedSections.contains(sectionId)) {
      newExpandedSections.remove(sectionId);
    } else {
      newExpandedSections.add(sectionId);
    }
    emit(state.copyWith(expandedSections: newExpandedSections));
  }

  void toggleWidget(String widgetId) {
    final newExpandedWidgets = Set<String>.from(state.expandedWidgets);
    if (newExpandedWidgets.contains(widgetId)) {
      newExpandedWidgets.remove(widgetId);
    } else {
      newExpandedWidgets.add(widgetId);
    }
    emit(state.copyWith(expandedWidgets: newExpandedWidgets));
  }

  void expandSections(Set<String> sectionIds) {
    final newExpandedSections = Set<String>.from(state.expandedSections)
      ..addAll(sectionIds);
    emit(state.copyWith(expandedSections: newExpandedSections));
  }

  void expandWidgets(Set<String> widgetIds) {
    final newExpandedWidgets = Set<String>.from(state.expandedWidgets)
      ..addAll(widgetIds);
    emit(state.copyWith(expandedWidgets: newExpandedWidgets));
  }

  void collapseSections(Set<String> sectionIds) {
    final newExpandedSections = Set<String>.from(state.expandedSections)
      ..removeAll(sectionIds);
    emit(state.copyWith(expandedSections: newExpandedSections));
  }

  void collapseWidgets(Set<String> widgetIds) {
    final newExpandedWidgets = Set<String>.from(state.expandedWidgets)
      ..removeAll(widgetIds);
    emit(state.copyWith(expandedWidgets: newExpandedWidgets));
  }

  void setExpansionState({
    required Set<String> sectionsToExpand,
    required Set<String> widgetsToExpand,
    required Set<String> sectionsToCollapse,
    required Set<String> widgetsToCollapse,
  }) {
    Set<String> newExpandedSections;
    Set<String> newExpandedWidgets;

    // If we have specific items to collapse/expand, use incremental update
    if (sectionsToCollapse.isNotEmpty || widgetsToCollapse.isNotEmpty) {
      newExpandedSections = Set<String>.from(state.expandedSections)
        ..removeAll(sectionsToCollapse)
        ..addAll(sectionsToExpand);

      newExpandedWidgets = Set<String>.from(state.expandedWidgets)
        ..removeAll(widgetsToCollapse)
        ..addAll(widgetsToExpand);
    } else {
      // If no items to collapse specified, replace entire state
      // This is for auto-expand where we only want specific items expanded
      newExpandedSections = Set<String>.from(sectionsToExpand);
      newExpandedWidgets = Set<String>.from(widgetsToExpand);
    }

    // Check if there are any actual changes
    if (newExpandedSections.length == state.expandedSections.length &&
        newExpandedSections.containsAll(state.expandedSections) &&
        newExpandedWidgets.length == state.expandedWidgets.length &&
        newExpandedWidgets.containsAll(state.expandedWidgets)) {
      return;
    }

    emit(state.copyWith(
      expandedSections: newExpandedSections,
      expandedWidgets: newExpandedWidgets,
    ));
  }
}

class PagebuilderHierarchyExpansionState {
  final Set<String> expandedSections;
  final Set<String> expandedWidgets;

  const PagebuilderHierarchyExpansionState({
    this.expandedSections = const {},
    this.expandedWidgets = const {},
  });

  PagebuilderHierarchyExpansionState copyWith({
    Set<String>? expandedSections,
    Set<String>? expandedWidgets,
  }) {
    return PagebuilderHierarchyExpansionState(
      expandedSections: expandedSections ?? this.expandedSections,
      expandedWidgets: expandedWidgets ?? this.expandedWidgets,
    );
  }
}

// TODO: WIDGET DUPLICATION
