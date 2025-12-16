import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';

abstract class PagebuilderSectionTemplateRepository {
  /// Loads all template metadata (id, type, thumbnailUrl) - lightweight
  Future<Either<DatabaseFailure, List<PagebuilderSectionTemplateMeta>>>
      getAllTemplateMetas();

  /// Loads full template with section data by ID
  Future<Either<DatabaseFailure, PagebuilderSectionTemplate>> getTemplateById(
      String id);
}
