// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_padding.dart';
import 'package:flutter/material.dart';

abstract class PageBuilderProperties {}

class PageBuilderWidget extends Equatable {
  final UniqueID id;
  final PageBuilderWidgetType? elementType;
  final PageBuilderProperties? properties;
  final List<PageBuilderWidget>? children;
  final PageBuilderWidget? containerChild;
  final double? widthPercentage;
  final Color? backgroundColor;
  final PageBuilderPadding? padding;

  const PageBuilderWidget(
      {required this.id,
      required this.elementType,
      required this.properties,
      required this.children,
      required this.containerChild,
      required this.widthPercentage,
      required this.backgroundColor,
      required this.padding});

  PageBuilderWidget copyWith(
      {UniqueID? id,
      PageBuilderWidgetType? elementType,
      PageBuilderProperties? properties,
      List<PageBuilderWidget>? children,
      PageBuilderWidget? containerChild,
      double? widthPercentage,
      Color? backgroundColor,
      PageBuilderPadding? padding}) {
    return PageBuilderWidget(
        id: id ?? this.id,
        elementType: elementType ?? this.elementType,
        properties: properties ?? this.properties,
        children: children ?? this.children,
        containerChild: containerChild ?? this.containerChild,
        widthPercentage: widthPercentage ?? this.widthPercentage,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        padding: padding ?? this.padding);
  }

  @override
  List<Object?> get props => [
        id,
        elementType,
        properties,
        children,
        containerChild,
        widthPercentage,
        backgroundColor,
        padding
      ];
}
