import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';

class PagebuilderSectionTemplateMetaModel extends Equatable {
  final String id;
  final SectionType type;
  final String thumbnailUrl;

  const PagebuilderSectionTemplateMetaModel({
    required this.id,
    required this.type,
    required this.thumbnailUrl,
  });

  factory PagebuilderSectionTemplateMetaModel.fromFirestore(
    Map<String, dynamic> map,
    String id,
  ) {
    return PagebuilderSectionTemplateMetaModel(
      id: id,
      type: SectionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => SectionType.hero,
      ),
      thumbnailUrl: map['thumbnailUrl'] as String,
    );
  }

  PagebuilderSectionTemplateMeta toDomain() {
    return PagebuilderSectionTemplateMeta(
      id: id,
      type: type,
      thumbnailUrl: thumbnailUrl,
    );
  }

  @override
  List<Object?> get props => [id, type, thumbnailUrl];
}
