import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section_template.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_section_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_section_template_meta_model.dart';

class PagebuilderSectionTemplateModel extends Equatable {
  final PagebuilderSectionTemplateMetaModel meta;
  final PageBuilderSectionModel section;

  const PagebuilderSectionTemplateModel({
    required this.meta,
    required this.section,
  });

  factory PagebuilderSectionTemplateModel.fromFirestore(
    Map<String, dynamic> map,
    String id,
  ) {
    return PagebuilderSectionTemplateModel(
      meta: PagebuilderSectionTemplateMetaModel.fromFirestore(map, id),
      section: PageBuilderSectionModel.fromMap(
        map['section'] as Map<String, dynamic>,
      ),
    );
  }

  PagebuilderSectionTemplate toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PagebuilderSectionTemplate(
      meta: meta.toDomain(),
      section: section.toDomain(globalStyles),
    );
  }

  @override
  List<Object?> get props => [meta, section];
}
