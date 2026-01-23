import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_edit.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder_section_template_asset_replacement_model.dart';

class PagebuilderSectionTemplateEditModel extends Equatable {
  final String templateId;
  final Uint8List? jsonData;
  final Uint8List? thumbnailData;
  final List<String> deletedAssetUrls;
  final List<PagebuilderSectionTemplateAssetReplacementModel> replacements;
  final List<Uint8List> newAssetDataList;
  final String environment;
  final String? type;

  const PagebuilderSectionTemplateEditModel({
    required this.templateId,
    this.jsonData,
    this.thumbnailData,
    this.deletedAssetUrls = const [],
    this.replacements = const [],
    this.newAssetDataList = const [],
    required this.environment,
    this.type,
  });

  factory PagebuilderSectionTemplateEditModel.fromDomain(
      PagebuilderSectionTemplateEdit edit) {
    return PagebuilderSectionTemplateEditModel(
      templateId: edit.templateId,
      jsonData: edit.jsonData,
      thumbnailData: edit.thumbnailData,
      deletedAssetUrls: edit.deletedAssetUrls,
      replacements: edit.replacements
          .map((r) =>
              PagebuilderSectionTemplateAssetReplacementModel.fromDomain(r))
          .toList(),
      newAssetDataList: edit.newAssetDataList,
      environment: edit.environment,
      type: edit.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'templateId': templateId,
      if (jsonData != null) 'jsonData': jsonData,
      if (thumbnailData != null) 'thumbnailData': thumbnailData,
      'deletedAssetUrls': deletedAssetUrls,
      'replacements': replacements.map((r) => r.toMap()).toList(),
      'newAssetDataList': newAssetDataList,
      'environment': environment,
      if (type != null) 'type': type,
    };
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
