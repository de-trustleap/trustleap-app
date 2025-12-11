// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_global_styles_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_model.dart';
import 'package:flutter/material.dart';

class PageBuilderPageModel extends Equatable {
  final String id;
  final List<Map<String, dynamic>>? sections;
  final String? backgroundColor;
  final Map<String, dynamic>? globalStyles;

  const PageBuilderPageModel({
    required this.id,
    required this.sections,
    required this.backgroundColor,
    required this.globalStyles,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (sections != null) map['sections'] = sections;
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    if (globalStyles != null) map['globalStyles'] = globalStyles;
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
            : null,
        globalStyles: map['globalStyles'] != null
            ? map['globalStyles'] as Map<String, dynamic>
            : null);
  }

  PageBuilderPageModel copyWith({
    String? id,
    List<Map<String, dynamic>>? sections,
    String? backgroundColor,
    Map<String, dynamic>? globalStyles,
  }) {
    return PageBuilderPageModel(
      id: id ?? this.id,
      sections: sections ?? this.sections,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      globalStyles: globalStyles ?? this.globalStyles,
    );
  }

  factory PageBuilderPageModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return PageBuilderPageModel.fromMap(doc).copyWith(id: id);
  }

  PageBuilderPage toDomain() {
    // Get global styles first
    final globalStylesDomain = getGlobalStylesFromMap(globalStyles);

    // Resolve backgroundColor token if needed
    Color? resolvedBackgroundColor;
    String? bgColorToken;
    if (backgroundColor != null) {
      if (backgroundColor!.startsWith('@')) {
        // Store token and resolve it
        bgColorToken = backgroundColor;
        final resolvedColor = globalStylesDomain?.resolveColorReference(backgroundColor!);
        resolvedBackgroundColor = resolvedColor;
      } else {
        resolvedBackgroundColor = Color(ColorUtility.getHexIntFromString(backgroundColor!));
        bgColorToken = null;
      }
    }

    final domainSections = getPageBuilderSectionList(sections, globalStylesDomain);

    return PageBuilderPage(
      id: UniqueID.fromUniqueString(id),
      backgroundColor: resolvedBackgroundColor,
      globalBackgroundColorToken: bgColorToken,
      sections: domainSections,
      globalStyles: globalStylesDomain,
    );
  }

  factory PageBuilderPageModel.fromDomain(PageBuilderPage page) {
    // Use token if present, otherwise convert color to hex
    final bgColorValue = page.globalBackgroundColorToken ??
        (page.backgroundColor != null ? ColorUtility.colorToHex(page.backgroundColor!) : null);

    return PageBuilderPageModel(
      id: page.id.value,
      backgroundColor: bgColorValue,
      sections: getMapFromPageBuilderSectionList(page.sections),
      globalStyles: getMapFromGlobalStyles(page.globalStyles),
    );
  }

  List<PageBuilderSection>? getPageBuilderSectionList(
      List<Map<String, dynamic>>? sections, PageBuilderGlobalStyles? globalStyles) {
    if (sections == null) {
      return null;
    }
    final sectionModels =
        sections.map((map) => PageBuilderSectionModel.fromMap(map)).toList();
    return sectionModels.map((model) => model.toDomain(globalStyles)).toList();
  }

  PageBuilderGlobalStyles? getGlobalStylesFromMap(
      Map<String, dynamic>? globalStyles) {
    if (globalStyles == null) {
      return null;
    }
    return PageBuilderGlobalStylesModel.fromMap(globalStyles).toDomain();
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

  static Map<String, dynamic>? getMapFromGlobalStyles(
      PageBuilderGlobalStyles? globalStyles) {
    if (globalStyles == null) {
      return null;
    }
    return PageBuilderGlobalStylesModel.fromDomain(globalStyles).toMap();
  }

  @override
  List<Object?> get props => [id, sections, backgroundColor, globalStyles];
}
