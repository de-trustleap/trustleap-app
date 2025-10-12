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
