part of 'pagebuilder_section_template_upload_cubit.dart';

sealed class PagebuilderSectionTemplateUploadState {}

final class PagebuilderSectionTemplateUploadInitial
    extends PagebuilderSectionTemplateUploadState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PagebuilderSectionTemplateUploadLoading
    extends PagebuilderSectionTemplateUploadState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PagebuilderSectionTemplateUploadSuccess
    extends PagebuilderSectionTemplateUploadState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PagebuilderSectionTemplateUploadFailure
    extends PagebuilderSectionTemplateUploadState with EquatableMixin {
  final DatabaseFailure failure;

  PagebuilderSectionTemplateUploadFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class PagebuilderSectionTemplateEditLoading
    extends PagebuilderSectionTemplateUploadState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PagebuilderSectionTemplateEditSuccess
    extends PagebuilderSectionTemplateUploadState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PagebuilderSectionTemplateEditFailure
    extends PagebuilderSectionTemplateUploadState with EquatableMixin {
  final DatabaseFailure failure;

  PagebuilderSectionTemplateEditFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
