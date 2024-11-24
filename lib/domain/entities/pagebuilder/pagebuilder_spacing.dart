// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PageBuilderSpacing extends Equatable {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const PageBuilderSpacing({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  PageBuilderSpacing copyWith({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return PageBuilderSpacing(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  factory PageBuilderSpacing.fromMap(Map<String, dynamic>? map) {
    final paddingTop = map?['top'] != null ? map!['top'] as double : 0.0;
    final paddingBottom =
        map?['bottom'] != null ? map!['bottom'] as double : 0.0;
    final paddingLeft = map?['left'] != null ? map!['left'] as double : 0.0;
    final paddingRight = map?['right'] != null ? map!['right'] as double : 0.0;

    return PageBuilderSpacing(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight);
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}
