part of 'pagebuilder_section_template_cubit.dart';

sealed class PagebuilderSectionTemplateState {}

final class PagebuilderSectionTemplateInitial
    extends PagebuilderSectionTemplateState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PagebuilderSectionTemplateLoading
    extends PagebuilderSectionTemplateState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PagebuilderSectionTemplateMetasLoadSuccess
    extends PagebuilderSectionTemplateState with EquatableMixin {
  final List<PagebuilderSectionTemplateMeta> metas;

  PagebuilderSectionTemplateMetasLoadSuccess({required this.metas});

  @override
  List<Object?> get props => [metas];
}

final class PagebuilderSectionTemplateFullLoadSuccess
    extends PagebuilderSectionTemplateState with EquatableMixin {
  final PagebuilderSectionTemplate template;

  PagebuilderSectionTemplateFullLoadSuccess({required this.template});

  @override
  List<Object?> get props => [template];
}

final class PagebuilderSectionTemplateFailure
    extends PagebuilderSectionTemplateState with EquatableMixin {
  final DatabaseFailure failure;

  PagebuilderSectionTemplateFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
