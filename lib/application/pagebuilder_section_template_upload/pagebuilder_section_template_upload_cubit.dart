import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_edit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_upload.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_section_template_upload_repository.dart';

part 'pagebuilder_section_template_upload_state.dart';

class PagebuilderSectionTemplateUploadCubit
    extends Cubit<PagebuilderSectionTemplateUploadState> {
  final PagebuilderSectionTemplateUploadRepository repository;

  PagebuilderSectionTemplateUploadCubit(this.repository)
      : super(PagebuilderSectionTemplateUploadInitial());

  void uploadTemplate(PagebuilderSectionTemplateUpload template) async {
    emit(PagebuilderSectionTemplateUploadLoading());
    final failureOrSuccess = await repository.uploadTemplate(template);
    failureOrSuccess.fold(
      (failure) =>
          emit(PagebuilderSectionTemplateUploadFailure(failure: failure)),
      (_) => emit(PagebuilderSectionTemplateUploadSuccess()),
    );
  }

  void editTemplate(PagebuilderSectionTemplateEdit template) async {
    emit(PagebuilderSectionTemplateEditLoading());
    final failureOrSuccess = await repository.editTemplate(template);
    failureOrSuccess.fold(
      (failure) =>
          emit(PagebuilderSectionTemplateEditFailure(failure: failure)),
      (_) => emit(PagebuilderSectionTemplateEditSuccess()),
    );
  }
}
