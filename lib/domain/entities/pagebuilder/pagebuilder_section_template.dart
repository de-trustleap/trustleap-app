import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';

class PagebuilderSectionTemplate extends Equatable {
  final PagebuilderSectionTemplateMeta meta;
  final PageBuilderSection section;

  const PagebuilderSectionTemplate({
    required this.meta,
    required this.section,
  });

  @override
  List<Object?> get props => [meta, section];
}
