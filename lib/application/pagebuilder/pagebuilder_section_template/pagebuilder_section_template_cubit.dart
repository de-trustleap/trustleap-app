import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_section_template_repository.dart';

part 'pagebuilder_section_template_state.dart';

class PagebuilderSectionTemplateCubit
    extends Cubit<PagebuilderSectionTemplateState> {
  final PagebuilderSectionTemplateRepository repository;

  PagebuilderSectionTemplateCubit(this.repository)
      : super(PagebuilderSectionTemplateInitial());

  void getAllTemplateMetas() async {
    emit(PagebuilderSectionTemplateLoading());

    final failureOrSuccess = await repository.getAllTemplateMetas();

    failureOrSuccess.fold(
      (failure) => emit(PagebuilderSectionTemplateFailure(failure: failure)),
      (metas) =>
          emit(PagebuilderSectionTemplateMetasLoadSuccess(metas: metas)),
    );
  }

  void getTemplateById(String id) async {
    emit(PagebuilderSectionTemplateLoading());

    final failureOrSuccess = await repository.getTemplateById(id);

    failureOrSuccess.fold(
      (failure) => emit(PagebuilderSectionTemplateFailure(failure: failure)),
      (template) => emit(
          PagebuilderSectionTemplateFullLoadSuccess(template: template)),
    );
  }
}
