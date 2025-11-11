// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PagebuilderBorder extends Equatable {
  final double? width;
  final double? radius;
  final Color? color;

  const PagebuilderBorder({
    required this.width,
    required this.radius,
    required this.color,
  });

  PagebuilderBorder copyWith({
    double? width,
    double? radius,
    Color? color,
  }) {
    return PagebuilderBorder(
      width: width ?? this.width,
      radius: radius ?? this.radius,
      color: color ?? this.color,
    );
  }

  PagebuilderBorder deepCopy() {
    return PagebuilderBorder(
      width: width,
      radius: radius,
      color: color != null ? Color(color!.toARGB32()) : null,
    );
  }

  @override
  List<Object?> get props => [width, radius, color];
}
