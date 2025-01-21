// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page_template.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_page_model.dart';

class LandingPageTemplateModel extends Equatable {
  final String id;
  final String? name;
  final String? thumbnailDownloadURL;
  final Map<String, dynamic>? page;

  const LandingPageTemplateModel({
    required this.id,
    required this.name,
    required this.thumbnailDownloadURL,
    required this.page,
  });

  LandingPageTemplateModel copyWith({
    String? id,
    String? name,
    String? thumbnailDownloadURL,
    Map<String, dynamic>? page,
  }) {
    return LandingPageTemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (name != null) map['name'] = name;
    if (thumbnailDownloadURL != null) {
      map['thumbnailDownloadURL'] = thumbnailDownloadURL;
    }
    if (page != null) map['page'] = page;
    return map;
  }

  factory LandingPageTemplateModel.fromMap(Map<String, dynamic> map) {
    return LandingPageTemplateModel(
      id: "",
      name: map['name'] != null ? map['name'] as String : null,
      thumbnailDownloadURL: map['thumbnailDownloadURL'] != null
          ? map['thumbnailDownloadURL'] as String
          : null,
      page: map['page'] != null ? map['page'] as Map<String, dynamic> : null,
    );
  }

  factory LandingPageTemplateModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return LandingPageTemplateModel.fromMap(doc).copyWith(id: id);
  }

  LandingPageTemplate toDomain() {
    return LandingPageTemplate(
        id: UniqueID.fromUniqueString(id),
        name: name,
        thumbnailDownloadURL: thumbnailDownloadURL,
        page: PageBuilderPageModel.fromMap(page ?? {}).toDomain());
  }

  factory LandingPageTemplateModel.fromDomain(LandingPageTemplate template) {
    return LandingPageTemplateModel(
        id: template.id.value,
        name: template.name,
        thumbnailDownloadURL: template.thumbnailDownloadURL,
        page: template.page != null
            ? PageBuilderPageModel.fromDomain(template.page!).toMap()
            : null);
  }

  @override
  List<Object?> get props => [id, name, thumbnailDownloadURL, page];
}
