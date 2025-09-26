// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderImageProperties extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;
  final double? width;
  final double? height;
  final BoxFit? contentMode;
  final PagebuilderPaint? overlayPaint;
  final bool? showPromoterImage;

  final Uint8List? localImage;
  final bool hasChanged;

  const PageBuilderImageProperties(
      {required this.url,
      required this.borderRadius,
      required this.width,
      required this.height,
      required this.contentMode,
      required this.overlayPaint,
      required this.showPromoterImage,
      this.localImage,
      this.hasChanged = false});

  PageBuilderImageProperties copyWith(
      {String? url,
      double? borderRadius,
      double? width,
      double? height,
      BoxFit? contentMode,
      PagebuilderPaint? overlayPaint,
      bool? showPromoterImage,
      Uint8List? localImage,
      bool? hasChanged}) {
    return PageBuilderImageProperties(
        url: url ?? this.url,
        borderRadius: borderRadius ?? this.borderRadius,
        width: width ?? this.width,
        height: height ?? this.height,
        contentMode: contentMode ?? this.contentMode,
        overlayPaint: overlayPaint ?? this.overlayPaint,
        showPromoterImage: showPromoterImage ?? this.showPromoterImage,
        localImage: localImage ?? this.localImage,
        hasChanged: hasChanged ?? this.hasChanged);
  }

  PageBuilderImageProperties deepCopy() {
    return PageBuilderImageProperties(
      url: url,
      borderRadius: borderRadius,
      width: width,
      height: height,
      contentMode: contentMode,
      overlayPaint: overlayPaint?.deepCopy(),
      showPromoterImage: showPromoterImage,
      localImage: localImage != null ? Uint8List.fromList(localImage!) : null,
      hasChanged: hasChanged,
    );
  }

  @override
  List<Object?> get props => [
        url,
        borderRadius,
        width,
        height,
        contentMode,
        overlayPaint,
        showPromoterImage,
        localImage
      ];
}
