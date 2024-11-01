part of 'pagebuilder_config_menu_cubit.dart';

sealed class PagebuilderConfigMenuState {}

final class PagebuilderConfigMenuInitial extends PagebuilderConfigMenuState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PageBuilderConfigMenuOpenedState extends PagebuilderConfigMenuState
    with EquatableMixin {
  final PageBuilderWidget model;

  PageBuilderConfigMenuOpenedState({required this.model});

  @override
  List<Object?> get props => [model];
}
