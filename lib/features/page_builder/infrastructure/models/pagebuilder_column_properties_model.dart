import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/model_helper/axis_alignment_mapper.dart';

class PagebuilderColumnPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? mainAxisAlignment;
  final String? crossAxisAlignment;

  final AxisAlignmentMapper alignmentMapper = AxisAlignmentMapper();

  PagebuilderColumnPropertiesModel(
      {required this.mainAxisAlignment, required this.crossAxisAlignment});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (mainAxisAlignment != null) map['mainAxisAlignment'] = mainAxisAlignment;
    if (crossAxisAlignment != null) {
      map['crossAxisAlignment'] = crossAxisAlignment;
    }
    return map;
  }

  factory PagebuilderColumnPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderColumnPropertiesModel(
        mainAxisAlignment: map['mainAxisAlignment'] != null
            ? map['mainAxisAlignment'] as String
            : null,
        crossAxisAlignment: map['crossAxisAlignment'] != null
            ? map['crossAxisAlignment'] as String
            : null);
  }

  PagebuilderColumnPropertiesModel copyWith(
      {String? mainAxisAlignment, String? crossAxisAlignment}) {
    return PagebuilderColumnPropertiesModel(
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment);
  }

  PagebuilderColumnProperties toDomain() {
    return PagebuilderColumnProperties(
        mainAxisAlignment:
            alignmentMapper.getMainAxisAlignmentFromString(mainAxisAlignment),
        crossAxisAlignment: alignmentMapper
            .getCrossAxisAlignmentFromString(crossAxisAlignment));
  }

  factory PagebuilderColumnPropertiesModel.fromDomain(
      PagebuilderColumnProperties properties) {
    return PagebuilderColumnPropertiesModel(
        mainAxisAlignment: AxisAlignmentMapper.getStringFromMainAxisAlignment(
            properties.mainAxisAlignment),
        crossAxisAlignment: AxisAlignmentMapper.getStringFromCrossAxisAlignment(
            properties.crossAxisAlignment));
  }

  @override
  List<Object?> get props => [mainAxisAlignment, crossAxisAlignment];
}
