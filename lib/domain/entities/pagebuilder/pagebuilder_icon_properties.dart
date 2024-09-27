// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderIconProperties extends Equatable implements PageBuilderProperties {
  final String? code;
  final double? size;
  final Color? color; 

  const PageBuilderIconProperties({
    this.code,
    this.size,
    this.color,
  });

  PageBuilderIconProperties copyWith({
    String? code,
    double? size,
    Color? color,
  }) {
    return PageBuilderIconProperties(
      code: code ?? this.code,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [code, size, color];
}
