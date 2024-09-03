// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_model.dart';

class PageBuilderPageModel extends Equatable {
  final String id;
  final List<Map<String, dynamic>>? sections;

  const PageBuilderPageModel({
    required this.id,
    required this.sections,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'sections': sections};
  }

  factory PageBuilderPageModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderPageModel(
        id: "",
        sections: map['sections'] != null
            ? List<Map<String, dynamic>>.from((map['sections'] as List)
                .map((item) => item as Map<String, dynamic>))
            : null);
  }

  PageBuilderPageModel copyWith({
    String? id,
    List<Map<String, dynamic>>? sections,
  }) {
    return PageBuilderPageModel(
      id: id ?? this.id,
      sections: sections ?? this.sections,
    );
  }

  factory PageBuilderPageModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return PageBuilderPageModel.fromMap(doc).copyWith(id: id);
  }

  PageBuilderPage toDomain() {
    return PageBuilderPage(
        id: UniqueID.fromUniqueString(id),
        sections: _getPageBuilderSectionList(sections));
  }

  factory PageBuilderPageModel.fromDomain(PageBuilderPage page) {
    return PageBuilderPageModel(
        id: page.id.value,
        sections: _getMapFromPageBuilderSectionList(page.sections));
  }

  List<PageBuilderSection>? _getPageBuilderSectionList(
      List<Map<String, dynamic>>? sections) {
    if (sections == null) {
      return null;
    }
    final sectionModels =
        sections.map((map) => PageBuilderSectionModel.fromMap(map)).toList();
    return sectionModels.map((model) => model.toDomain()).toList();
  }

  static List<Map<String, dynamic>>? _getMapFromPageBuilderSectionList(
      List<PageBuilderSection>? sections) {
    if (sections == null) {
      return null;
    }
    final widgetModels = sections
        .map((section) => PageBuilderSectionModel.fromDomain(section))
        .toList();
    return widgetModels.map((model) => model.toMap()).toList();
  }

  @override
  List<Object?> get props => [id];
}
