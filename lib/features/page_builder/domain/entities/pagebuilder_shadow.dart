// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PageBuilderShadow extends Equatable {
  final Color? color;
  final String? globalColorToken;
  final double? spreadRadius;
  final double? blurRadius;
  final Offset? offset;

  const PageBuilderShadow({
    required this.color,
    this.globalColorToken,
    required this.spreadRadius,
    required this.blurRadius,
    required this.offset,
  });

  PageBuilderShadow copyWith({
    Color? color,
    String? globalColorToken,
    double? spreadRadius,
    double? blurRadius,
    Offset? offset,
    bool setGlobalColorTokenNull = false,
  }) {
    return PageBuilderShadow(
      color: color ?? this.color,
      globalColorToken: setGlobalColorTokenNull ? null : (globalColorToken ?? this.globalColorToken),
      spreadRadius: spreadRadius ?? this.spreadRadius,
      blurRadius: blurRadius ?? this.blurRadius,
      offset: offset ?? this.offset,
    );
  }

  PageBuilderShadow deepCopy() {
    return PageBuilderShadow(
      color: color != null ? Color(color!.toARGB32()) : null,
      globalColorToken: globalColorToken,
      spreadRadius: spreadRadius,
      blurRadius: blurRadius,
      offset: offset != null ? Offset(offset!.dx, offset!.dy) : null,
    );
  }

  @override
  List<Object?> get props => [color, globalColorToken, spreadRadius, blurRadius, offset];
}
