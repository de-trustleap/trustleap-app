// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderImageProperties extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;
  final double? width;
  final double? height;
  final BoxFit? contentMode;
  final Color? overlayColor;

  final Uint8List? localImage;
  final bool hasChanged;

  const PageBuilderImageProperties(
      {required this.url,
      required this.borderRadius,
      required this.width,
      required this.height,
      required this.contentMode,
      required this.overlayColor,
      this.localImage,
      this.hasChanged = false});

  PageBuilderImageProperties copyWith(
      {String? url,
      double? borderRadius,
      double? width,
      double? height,
      BoxFit? contentMode,
      Color? overlayColor,
      Uint8List? localImage,
      bool? hasChanged}) {
    return PageBuilderImageProperties(
        url: url ?? this.url,
        borderRadius: borderRadius ?? this.borderRadius,
        width: width ?? this.width,
        height: height ?? this.height,
        contentMode: contentMode ?? this.contentMode,
        overlayColor: overlayColor ?? this.overlayColor,
        localImage: localImage ?? this.localImage,
        hasChanged: hasChanged ?? this.hasChanged);
  }

  @override
  List<Object?> get props =>
      [url, borderRadius, width, height, contentMode, overlayColor, localImage];
}
