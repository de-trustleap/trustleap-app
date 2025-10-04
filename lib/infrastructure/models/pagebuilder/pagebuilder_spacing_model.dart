// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';

class PageBuilderSpacingModel extends Equatable {
  final PagebuilderResponsiveOrConstantModel<double>? top;
  final PagebuilderResponsiveOrConstantModel<double>? bottom;
  final PagebuilderResponsiveOrConstantModel<double>? left;
  final PagebuilderResponsiveOrConstantModel<double>? right;

  const PageBuilderSpacingModel({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  Map<String, dynamic>? toMap() {
    Map<String, dynamic> map = {};
    final topValue = top?.toMapValue();
    final bottomValue = bottom?.toMapValue();
    final leftValue = left?.toMapValue();
    final rightValue = right?.toMapValue();

    if (topValue != null && topValue != 0) {
      map['top'] = topValue;
    }
    if (bottomValue != null && bottomValue != 0) {
      map['bottom'] = bottomValue;
    }
    if (leftValue != null && leftValue != 0) {
      map['left'] = leftValue;
    }
    if (rightValue != null && rightValue != 0) {
      map['right'] = rightValue;
    }

    if (map.isEmpty) return null;
    return map;
  }

  factory PageBuilderSpacingModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const PageBuilderSpacingModel(
        top: PagebuilderResponsiveOrConstantModel.constant(0.0),
        bottom: PagebuilderResponsiveOrConstantModel.constant(0.0),
        left: PagebuilderResponsiveOrConstantModel.constant(0.0),
        right: PagebuilderResponsiveOrConstantModel.constant(0.0),
      );
    }

    return PageBuilderSpacingModel(
      top: PagebuilderResponsiveOrConstantModel.fromMapValue(
        map['top'],
        (v) => v as double,
      ) ?? const PagebuilderResponsiveOrConstantModel.constant(0.0),
      bottom: PagebuilderResponsiveOrConstantModel.fromMapValue(
        map['bottom'],
        (v) => v as double,
      ) ?? const PagebuilderResponsiveOrConstantModel.constant(0.0),
      left: PagebuilderResponsiveOrConstantModel.fromMapValue(
        map['left'],
        (v) => v as double,
      ) ?? const PagebuilderResponsiveOrConstantModel.constant(0.0),
      right: PagebuilderResponsiveOrConstantModel.fromMapValue(
        map['right'],
        (v) => v as double,
      ) ?? const PagebuilderResponsiveOrConstantModel.constant(0.0),
    );
  }

  PageBuilderSpacing toDomain() {
    return PageBuilderSpacing(
      top: top?.toDomain(),
      bottom: bottom?.toDomain(),
      left: left?.toDomain(),
      right: right?.toDomain(),
    );
  }

  factory PageBuilderSpacingModel.fromDomain(PageBuilderSpacing? spacing) {
    if (spacing == null) {
      return const PageBuilderSpacingModel(
        top: PagebuilderResponsiveOrConstantModel.constant(0.0),
        bottom: PagebuilderResponsiveOrConstantModel.constant(0.0),
        left: PagebuilderResponsiveOrConstantModel.constant(0.0),
        right: PagebuilderResponsiveOrConstantModel.constant(0.0),
      );
    }
    return PageBuilderSpacingModel(
      top: PagebuilderResponsiveOrConstantModel.fromDomain(spacing.top),
      bottom: PagebuilderResponsiveOrConstantModel.fromDomain(spacing.bottom),
      left: PagebuilderResponsiveOrConstantModel.fromDomain(spacing.left),
      right: PagebuilderResponsiveOrConstantModel.fromDomain(spacing.right),
    );
  }

  PageBuilderSpacingModel copyWith({
    PagebuilderResponsiveOrConstantModel<double>? top,
    PagebuilderResponsiveOrConstantModel<double>? bottom,
    PagebuilderResponsiveOrConstantModel<double>? left,
    PagebuilderResponsiveOrConstantModel<double>? right,
  }) {
    return PageBuilderSpacingModel(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}
