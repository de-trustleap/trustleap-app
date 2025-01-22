part of 'pagebuilder_config_menu_cubit.dart';

sealed class PagebuilderConfigMenuState {}

final class PagebuilderConfigMenuInitial extends PagebuilderConfigMenuState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PageBuilderConfigMenuOpenedState extends PagebuilderConfigMenuState
    with EquatableMixin {
  // id is needed here to make sure that the blocbuilder reloads when models are the same.
  final UniqueID id;
  final PageBuilderWidget model;

  PageBuilderConfigMenuOpenedState({required this.id, required this.model});

  @override
  List<Object?> get props => [id, model];
}

final class PageBuilderSectionConfigMenuOpenedState
    extends PagebuilderConfigMenuState with EquatableMixin {
  final UniqueID id;
  final PageBuilderSection model;

  PageBuilderSectionConfigMenuOpenedState(
      {required this.id, required this.model});

  @override
  List<Object?> get props => [id, model];
}
