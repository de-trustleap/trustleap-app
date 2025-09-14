// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_model.dart';
import 'package:flutter/material.dart';

class PageBuilderPageModel extends Equatable {
  final String id;
  final List<Map<String, dynamic>>? sections;
  final String? backgroundColor;

  const PageBuilderPageModel(
      {required this.id,
      required this.sections,
      required this.backgroundColor});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (sections != null) map['sections'] = sections;
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    return map;
  }

  factory PageBuilderPageModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderPageModel(
        id: "",
        backgroundColor: map['backgroundColor'] != null
            ? map['backgroundColor'] as String
            : null,
        sections: map['sections'] != null
            ? List<Map<String, dynamic>>.from((map['sections'] as List)
                .map((item) => item as Map<String, dynamic>))
            : null);
  }

  PageBuilderPageModel copyWith(
      {String? id,
      List<Map<String, dynamic>>? sections,
      String? backgroundColor}) {
    return PageBuilderPageModel(
        id: id ?? this.id,
        sections: sections ?? this.sections,
        backgroundColor: backgroundColor ?? this.backgroundColor);
  }

  factory PageBuilderPageModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return PageBuilderPageModel.fromMap(doc).copyWith(id: id);
  }

  PageBuilderPage toDomain() {
    return PageBuilderPage(
        id: UniqueID.fromUniqueString(id),
        backgroundColor: backgroundColor != null
            ? Color(ColorUtility.getHexIntFromString(backgroundColor!))
            : null,
        sections: getPageBuilderSectionList(sections));
  }

  factory PageBuilderPageModel.fromDomain(PageBuilderPage page) {
    return PageBuilderPageModel(
        id: page.id.value,
        backgroundColor: page.backgroundColor != null
            ? ColorUtility.colorToHex(page.backgroundColor!)
            : null,
        sections: getMapFromPageBuilderSectionList(page.sections));
  }

  List<PageBuilderSection>? getPageBuilderSectionList(
      List<Map<String, dynamic>>? sections) {
    if (sections == null) {
      return null;
    }
    final sectionModels =
        sections.map((map) => PageBuilderSectionModel.fromMap(map)).toList();
    return sectionModels.map((model) => model.toDomain()).toList();
  }

  static List<Map<String, dynamic>>? getMapFromPageBuilderSectionList(
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
  List<Object?> get props => [id, sections, backgroundColor];
}
