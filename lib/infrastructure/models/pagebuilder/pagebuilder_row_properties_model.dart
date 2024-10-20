// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/axis_alignment_mapper.dart';

class PagebuilderRowPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final bool? equalHeights;
  final String? mainAxisAlignment;
  final String? crossAxisAlignment;

  final AxisAlignmentMapper alignmentMapper = AxisAlignmentMapper();

  PagebuilderRowPropertiesModel(
      {required this.equalHeights,
      required this.mainAxisAlignment,
      required this.crossAxisAlignment});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (equalHeights != null) map['equalHeights'] = equalHeights;
    if (mainAxisAlignment != null) map['mainAxisAlignment'] = mainAxisAlignment;
    if (crossAxisAlignment != null) {
      map['crossAxisAlignment'] = crossAxisAlignment;
    }
    return map;
  }

  factory PagebuilderRowPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderRowPropertiesModel(
        equalHeights:
            map['equalHeights'] != null ? map['equalHeights'] as bool : null,
        mainAxisAlignment: map['mainAxisAlignment'] != null
            ? map['mainAxisAlignment'] as String
            : null,
        crossAxisAlignment: map['crossAxisAlignment'] != null
            ? map['crossAxisAlignment'] as String
            : null);
  }

  PagebuilderRowPropertiesModel copyWith(
      {bool? equalHeights,
      String? mainAxisAlignment,
      String? crossAxisAlignment}) {
    return PagebuilderRowPropertiesModel(
        equalHeights: equalHeights ?? this.equalHeights,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment);
  }

  PagebuilderRowProperties toDomain() {
    return PagebuilderRowProperties(
        equalHeights: equalHeights,
        mainAxisAlignment:
            alignmentMapper.getMainAxisAlignmentFromString(mainAxisAlignment),
        crossAxisAlignment: alignmentMapper
            .getCrossAxisAlignmentFromString(crossAxisAlignment));
  }

  factory PagebuilderRowPropertiesModel.fromDomain(
      PagebuilderRowProperties properties) {
    return PagebuilderRowPropertiesModel(
        equalHeights: properties.equalHeights,
        mainAxisAlignment: AxisAlignmentMapper.getStringFromMainAxisAlignment(
            properties.mainAxisAlignment),
        crossAxisAlignment: AxisAlignmentMapper.getStringFromCrossAxisAlignment(
            properties.crossAxisAlignment));
  }

  @override
  List<Object?> get props =>
      [equalHeights, mainAxisAlignment, crossAxisAlignment];
}

// TODO: Nutze die neuen Properties in der PageBuilderRow und packe sie ins JSON File (TESTEN!)
// TODO: Das gleiche dann noch für Column Properties (TESTEN!)
// TODO: Auch im Backend hinzufügen
// TODO: equalWidths in equalHeights umbenennen (NOCH IM BACKEND MACHEN!)
// TODO: Alignment ins Backend