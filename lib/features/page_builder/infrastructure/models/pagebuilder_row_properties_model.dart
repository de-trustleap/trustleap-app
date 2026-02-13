// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/model_helper/axis_alignment_mapper.dart';

class PagebuilderRowPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final bool? equalHeights;
  final String? mainAxisAlignment;
  final String? crossAxisAlignment;
  final List<String>? switchToColumnFor;

  final AxisAlignmentMapper alignmentMapper = AxisAlignmentMapper();

  PagebuilderRowPropertiesModel(
      {required this.equalHeights,
      required this.mainAxisAlignment,
      required this.crossAxisAlignment,
      required this.switchToColumnFor});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (equalHeights != null) map['equalHeights'] = equalHeights;
    if (mainAxisAlignment != null) map['mainAxisAlignment'] = mainAxisAlignment;
    if (crossAxisAlignment != null) {
      map['crossAxisAlignment'] = crossAxisAlignment;
    }
    if (switchToColumnFor != null) {
      map['switchToColumnFor'] = switchToColumnFor;
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
            : null,
        switchToColumnFor: map['switchToColumnFor'] != null
            ? List<String>.from(map['switchToColumnFor'] as List)
            : null);
  }

  PagebuilderRowPropertiesModel copyWith(
      {bool? equalHeights,
      String? mainAxisAlignment,
      String? crossAxisAlignment,
      List<String>? switchToColumnFor}) {
    return PagebuilderRowPropertiesModel(
        equalHeights: equalHeights ?? this.equalHeights,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
        switchToColumnFor: switchToColumnFor ?? this.switchToColumnFor);
  }

  PagebuilderRowProperties toDomain() {
    return PagebuilderRowProperties(
        equalHeights: equalHeights,
        mainAxisAlignment:
            alignmentMapper.getMainAxisAlignmentFromString(mainAxisAlignment),
        crossAxisAlignment: alignmentMapper
            .getCrossAxisAlignmentFromString(crossAxisAlignment),
        switchToColumnFor: switchToColumnFor
            ?.map((s) => _breakpointFromString(s))
            .whereType<PagebuilderResponsiveBreakpoint>()
            .toList());
  }

  factory PagebuilderRowPropertiesModel.fromDomain(
      PagebuilderRowProperties properties) {
    return PagebuilderRowPropertiesModel(
        equalHeights: properties.equalHeights,
        mainAxisAlignment: AxisAlignmentMapper.getStringFromMainAxisAlignment(
            properties.mainAxisAlignment),
        crossAxisAlignment: AxisAlignmentMapper.getStringFromCrossAxisAlignment(
            properties.crossAxisAlignment),
        switchToColumnFor: properties.switchToColumnFor
            ?.map((b) => _breakpointToString(b))
            .toList());
  }

  static PagebuilderResponsiveBreakpoint? _breakpointFromString(String? s) {
    if (s == null) return null;
    switch (s.toLowerCase()) {
      case 'desktop':
        return PagebuilderResponsiveBreakpoint.desktop;
      case 'tablet':
        return PagebuilderResponsiveBreakpoint.tablet;
      case 'mobile':
        return PagebuilderResponsiveBreakpoint.mobile;
      default:
        return null;
    }
  }

  static String _breakpointToString(PagebuilderResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.desktop:
        return 'Desktop';
      case PagebuilderResponsiveBreakpoint.tablet:
        return 'Tablet';
      case PagebuilderResponsiveBreakpoint.mobile:
        return 'Mobile';
    }
  }

  @override
  List<Object?> get props =>
      [equalHeights, mainAxisAlignment, crossAxisAlignment, switchToColumnFor];
}