import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_asset_replacement.dart';

class PagebuilderSectionTemplateEdit extends Equatable {
  final String templateId;
  final Uint8List? jsonData;
  final Uint8List? thumbnailData;
  final List<String> deletedAssetUrls;
  final List<PagebuilderSectionTemplateAssetReplacement> replacements;
  final List<Uint8List> newAssetDataList;
  final String environment;
  final String? type;

  const PagebuilderSectionTemplateEdit({
    required this.templateId,
    this.jsonData,
    this.thumbnailData,
    this.deletedAssetUrls = const [],
    this.replacements = const [],
    this.newAssetDataList = const [],
    required this.environment,
    this.type,
  });

  PagebuilderSectionTemplateEdit copyWith({
    String? templateId,
    Uint8List? jsonData,
    Uint8List? thumbnailData,
    List<String>? deletedAssetUrls,
    List<PagebuilderSectionTemplateAssetReplacement>? replacements,
    List<Uint8List>? newAssetDataList,
    String? environment,
    String? type,
  }) {
    return PagebuilderSectionTemplateEdit(
      templateId: templateId ?? this.templateId,
      jsonData: jsonData ?? this.jsonData,
      thumbnailData: thumbnailData ?? this.thumbnailData,
      deletedAssetUrls: deletedAssetUrls ?? this.deletedAssetUrls,
      replacements: replacements ?? this.replacements,
      newAssetDataList: newAssetDataList ?? this.newAssetDataList,
      environment: environment ?? this.environment,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
        templateId,
        jsonData,
        thumbnailData,
        deletedAssetUrls,
        replacements,
        newAssetDataList,
        environment,
        type,
      ];
}
