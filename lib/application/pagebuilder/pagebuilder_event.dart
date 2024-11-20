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

class SaveLandingPageContentEvent extends PagebuilderEvent with EquatableMixin {
  final PagebuilderContent? content;

  SaveLandingPageContentEvent(this.content);

  @override
  List<Object?> get props => [content];
}
