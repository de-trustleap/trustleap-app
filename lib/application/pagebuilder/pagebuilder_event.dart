part of 'pagebuilder_bloc.dart';

sealed class PagebuilderEvent {}

class GetLandingPageEvent extends PagebuilderEvent with EquatableMixin {
  final String id;

  GetLandingPageEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetLandingPageContentEvent extends PagebuilderEvent with EquatableMixin {
  final String id;
  final PagebuilderContent pageContent;

  GetLandingPageContentEvent(this.id, this.pageContent);

  @override
  List<Object?> get props => [id, pageContent];
}

class UpdateWidgetEvent extends PagebuilderEvent with EquatableMixin {
  final PageBuilderWidget updatedWidget;

  UpdateWidgetEvent(this.updatedWidget);

  @override
  List<Object?> get props => [updatedWidget];
}

class UpdateSectionEvent extends PagebuilderEvent with EquatableMixin {
  final PageBuilderSection updatedSection;

  UpdateSectionEvent(this.updatedSection);

  @override
  List<Object?> get props => [updatedSection];
}

class UpdatePageEvent extends PagebuilderEvent with EquatableMixin {
  final PageBuilderPage updatedPage;

  UpdatePageEvent(this.updatedPage);

  @override
  List<Object?> get props => [updatedPage];
}

class UpdateGlobalStylesEvent extends PagebuilderEvent with EquatableMixin {
  final PageBuilderGlobalStyles globalStyles;

  UpdateGlobalStylesEvent(this.globalStyles);

  @override
  List<Object?> get props => [globalStyles];
}

class ReorderSectionsEvent extends PagebuilderEvent with EquatableMixin {
  final int oldIndex;
  final int newIndex;

  ReorderSectionsEvent(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class ReorderWidgetEvent extends PagebuilderEvent with EquatableMixin {
  final String parentWidgetId;
  final int oldIndex;
  final int newIndex;

  ReorderWidgetEvent(this.parentWidgetId, this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [parentWidgetId, oldIndex, newIndex];
}

class SaveLandingPageContentEvent extends PagebuilderEvent with EquatableMixin {
  final PagebuilderContent? content;

  SaveLandingPageContentEvent(this.content);

  @override
  List<Object?> get props => [content];
}

class UndoPagebuilderEvent extends PagebuilderEvent with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RedoPagebuilderEvent extends PagebuilderEvent with EquatableMixin {
  @override
  List<Object?> get props => [];
}

enum DropPosition {
  before,
  after,
  above,
  below,
  inside,
}

class AddWidgetAtPositionEvent extends PagebuilderEvent with EquatableMixin {
  final PageBuilderWidget newWidget;
  final String targetWidgetId;
  final DropPosition position;

  AddWidgetAtPositionEvent({
    required this.newWidget,
    required this.targetWidgetId,
    required this.position,
  });

  @override
  List<Object?> get props => [newWidget, targetWidgetId, position];
}

class AddSectionEvent extends PagebuilderEvent with EquatableMixin {
  final int columnCount;

  AddSectionEvent(this.columnCount);

  @override
  List<Object?> get props => [columnCount];
}

class ReplacePlaceholderEvent extends PagebuilderEvent with EquatableMixin {
  final String placeholderId;
  final PageBuilderWidgetType widgetType;

  ReplacePlaceholderEvent({
    required this.placeholderId,
    required this.widgetType,
  });

  @override
  List<Object?> get props => [placeholderId, widgetType];
}

class DeleteSectionEvent extends PagebuilderEvent with EquatableMixin {
  final String sectionId;

  DeleteSectionEvent(this.sectionId);

  @override
  List<Object?> get props => [sectionId];
}

class DuplicateSectionEvent extends PagebuilderEvent with EquatableMixin {
  final String sectionId;

  DuplicateSectionEvent(this.sectionId);

  @override
  List<Object?> get props => [sectionId];
}

class DeleteWidgetEvent extends PagebuilderEvent with EquatableMixin {
  final String widgetId;

  DeleteWidgetEvent(this.widgetId);

  @override
  List<Object?> get props => [widgetId];
}

class DuplicateWidgetEvent extends PagebuilderEvent with EquatableMixin {
  final String widgetId;

  DuplicateWidgetEvent(this.widgetId);

  @override
  List<Object?> get props => [widgetId];
}
