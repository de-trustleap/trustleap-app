// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

class PageBuilderIconProperties extends Equatable
    implements PageBuilderProperties {
  final String? code;
  final PagebuilderResponsiveOrConstant<double>? size;
  final Color? color;
  final String? globalColorToken;

  const PageBuilderIconProperties({
    required this.code,
    required this.size,
    required this.color,
    this.globalColorToken,
  });

  PageBuilderIconProperties copyWith({
    String? code,
    PagebuilderResponsiveOrConstant<double>? size,
    Color? color,
    String? globalColorToken,
    bool setGlobalColorTokenNull = false,
  }) {
    return PageBuilderIconProperties(
      code: code ?? this.code,
      size: size ?? this.size,
      color: color ?? this.color,
      globalColorToken: setGlobalColorTokenNull
          ? null
          : (globalColorToken ?? this.globalColorToken),
    );
  }

  PageBuilderIconProperties deepCopy() {
    return PageBuilderIconProperties(
      code: code,
      size: size,
      color: color != null ? Color(color!.toARGB32()) : null,
      globalColorToken: globalColorToken,
    );
  }

  @override
  List<Object?> get props => [code, size, color];
}
