// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PageBuilderPadding extends Equatable {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const PageBuilderPadding({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  PageBuilderPadding copyWith({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return PageBuilderPadding(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  factory PageBuilderPadding.fromMap(Map<String, dynamic>? map) {
    final paddingTop = map?['top'] != null ? map!['top'] as double : 0.0;
    final paddingBottom =
        map?['bottom'] != null ? map!['bottom'] as double : 0.0;
    final paddingLeft = map?['left'] != null ? map!['left'] as double : 0.0;
    final paddingRight = map?['right'] != null ? map!['right'] as double : 0.0;

    return PageBuilderPadding(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight);
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}
