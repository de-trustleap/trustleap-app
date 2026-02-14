// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class PagebuilderSectionTemplateUpload extends Equatable {
  final Uint8List jsonData;
  final String jsonFileName;
  final Uint8List thumbnailData;
  final String thumbnailFileName;
  final List<Uint8List> assetDataList;
  final List<String> assetFileNames;
  final String environment;
  final String type;

  const PagebuilderSectionTemplateUpload({
    required this.jsonData,
    required this.jsonFileName,
    required this.thumbnailData,
    required this.thumbnailFileName,
    required this.assetDataList,
    required this.assetFileNames,
    required this.environment,
    required this.type,
  });

  PagebuilderSectionTemplateUpload copyWith({
    Uint8List? jsonData,
    String? jsonFileName,
    Uint8List? thumbnailData,
    String? thumbnailFileName,
    List<Uint8List>? assetDataList,
    List<String>? assetFileNames,
    String? environment,
    String? type,
  }) {
    return PagebuilderSectionTemplateUpload(
      jsonData: jsonData ?? this.jsonData,
      jsonFileName: jsonFileName ?? this.jsonFileName,
      thumbnailData: thumbnailData ?? this.thumbnailData,
      thumbnailFileName: thumbnailFileName ?? this.thumbnailFileName,
      assetDataList: assetDataList ?? this.assetDataList,
      assetFileNames: assetFileNames ?? this.assetFileNames,
      environment: environment ?? this.environment,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
        jsonData,
        jsonFileName,
        thumbnailData,
        thumbnailFileName,
        assetDataList,
        assetFileNames,
        environment,
        type,
      ];
}
