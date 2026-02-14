// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';

class PageBuilderSpacing extends Equatable {
  final PagebuilderResponsiveOrConstant<double>? top;
  final PagebuilderResponsiveOrConstant<double>? bottom;
  final PagebuilderResponsiveOrConstant<double>? left;
  final PagebuilderResponsiveOrConstant<double>? right;

  const PageBuilderSpacing({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  PageBuilderSpacing copyWith({
    PagebuilderResponsiveOrConstant<double>? top,
    PagebuilderResponsiveOrConstant<double>? bottom,
    PagebuilderResponsiveOrConstant<double>? left,
    PagebuilderResponsiveOrConstant<double>? right,
  }) {
    return PageBuilderSpacing(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  PageBuilderSpacing deepCopy() {
    return PageBuilderSpacing(
      top: top?.deepCopy(),
      bottom: bottom?.deepCopy(),
      left: left?.deepCopy(),
      right: right?.deepCopy(),
    );
  }

  factory PageBuilderSpacing.fromMap(Map<String, dynamic>? map) {
    final paddingTop = map?['top'] != null ? map!['top'] as double : 0.0;
    final paddingBottom =
        map?['bottom'] != null ? map!['bottom'] as double : 0.0;
    final paddingLeft = map?['left'] != null ? map!['left'] as double : 0.0;
    final paddingRight = map?['right'] != null ? map!['right'] as double : 0.0;

    return PageBuilderSpacing(
        top: PagebuilderResponsiveOrConstant.constant(paddingTop),
        bottom: PagebuilderResponsiveOrConstant.constant(paddingBottom),
        left: PagebuilderResponsiveOrConstant.constant(paddingLeft),
        right: PagebuilderResponsiveOrConstant.constant(paddingRight));
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}
