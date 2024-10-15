// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderRowPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final bool? equalWidths;

  const PagebuilderRowPropertiesModel({
    this.equalWidths,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (equalWidths != null) map['equalWidths'] = equalWidths;
    return map;
  }

  factory PagebuilderRowPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderRowPropertiesModel(
        equalWidths:
            map['equalWidths'] != null ? map['equalWidths'] as bool : null);
  }

  PagebuilderRowPropertiesModel copyWith({
    bool? equalWidths,
  }) {
    return PagebuilderRowPropertiesModel(
      equalWidths: equalWidths ?? this.equalWidths,
    );
  }

  PagebuilderRowProperties toDomain() {
    return PagebuilderRowProperties(equalWidths: equalWidths);
  }

  factory PagebuilderRowPropertiesModel.fromDomain(
      PagebuilderRowProperties properties) {
    return PagebuilderRowPropertiesModel(equalWidths: properties.equalWidths);
  }

  @override
  List<Object?> get props => [equalWidths];
}
