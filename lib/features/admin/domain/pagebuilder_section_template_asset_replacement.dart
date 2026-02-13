import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class PagebuilderSectionTemplateAssetReplacement extends Equatable {
  final String oldUrl;
  final Uint8List newAssetData;

  const PagebuilderSectionTemplateAssetReplacement({
    required this.oldUrl,
    required this.newAssetData,
  });

  @override
  List<Object?> get props => [oldUrl, newAssetData];
}
