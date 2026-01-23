import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_edit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_upload.dart';

abstract class PagebuilderSectionTemplateUploadRepository {
  Future<Either<DatabaseFailure, Unit>> uploadTemplate(
      PagebuilderSectionTemplateUpload template);

  Future<Either<DatabaseFailure, Unit>> editTemplate(
      PagebuilderSectionTemplateEdit template);
}
