// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_border.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

class PageBuilderImageProperties extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final PagebuilderBorder? border;
  final PagebuilderResponsiveOrConstant<double>? width;
  final PagebuilderResponsiveOrConstant<double>? height;
  final PagebuilderResponsiveOrConstant<BoxFit>? contentMode;
  final PagebuilderPaint? overlayPaint;
  final PageBuilderShadow? shadow;
  final bool? showPromoterImage;

  final Uint8List? localImage;
  final bool hasChanged;

  const PageBuilderImageProperties(
      {required this.url,
      required this.border,
      required this.width,
      required this.height,
      required this.contentMode,
      required this.overlayPaint,
      required this.shadow,
      required this.showPromoterImage,
      this.localImage,
      this.hasChanged = false});

  PageBuilderImageProperties copyWith(
      {String? url,
      PagebuilderBorder? border,
      PagebuilderResponsiveOrConstant<double>? width,
      PagebuilderResponsiveOrConstant<double>? height,
      PagebuilderResponsiveOrConstant<BoxFit>? contentMode,
      PagebuilderPaint? overlayPaint,
      PageBuilderShadow? shadow,
      bool? showPromoterImage,
      Uint8List? localImage,
      bool? hasChanged}) {
    return PageBuilderImageProperties(
        url: url ?? this.url,
        border: border ?? this.border,
        width: width ?? this.width,
        height: height ?? this.height,
        contentMode: contentMode ?? this.contentMode,
        overlayPaint: overlayPaint ?? this.overlayPaint,
        shadow: shadow ?? this.shadow,
        showPromoterImage: showPromoterImage ?? this.showPromoterImage,
        localImage: localImage ?? this.localImage,
        hasChanged: hasChanged ?? this.hasChanged);
  }

  PageBuilderImageProperties deepCopy() {
    return PageBuilderImageProperties(
      url: url,
      border: border?.deepCopy(),
      width: width?.deepCopy(),
      height: height?.deepCopy(),
      contentMode: contentMode?.deepCopy(),
      overlayPaint: overlayPaint?.deepCopy(),
      shadow: shadow?.deepCopy(),
      showPromoterImage: showPromoterImage,
      localImage: localImage != null ? Uint8List.fromList(localImage!) : null,
      hasChanged: hasChanged,
    );
  }

  @override
  List<Object?> get props => [
        url,
        border,
        width,
        height,
        contentMode,
        overlayPaint,
        shadow,
        showPromoterImage,
        localImage
      ];
}
