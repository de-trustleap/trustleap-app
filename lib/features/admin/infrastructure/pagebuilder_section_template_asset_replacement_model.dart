import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_asset_replacement.dart';

class PagebuilderSectionTemplateAssetReplacementModel extends Equatable {
  final String oldUrl;
  final Uint8List newAssetData;

  const PagebuilderSectionTemplateAssetReplacementModel({
    required this.oldUrl,
    required this.newAssetData,
  });

  factory PagebuilderSectionTemplateAssetReplacementModel.fromDomain(
      PagebuilderSectionTemplateAssetReplacement replacement) {
    return PagebuilderSectionTemplateAssetReplacementModel(
      oldUrl: replacement.oldUrl,
      newAssetData: replacement.newAssetData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'oldUrl': oldUrl,
      'newAssetBase64': newAssetData,
    };
  }

  @override
  List<Object?> get props => [oldUrl, newAssetData];
}
