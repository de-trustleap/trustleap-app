// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

abstract class PageBuilderProperties {}

class PageBuilderWidget extends Equatable {
  final UniqueID id;
  final PageBuilderWidgetType? elementType;
  final PageBuilderProperties? properties;
  final List<PageBuilderWidget>? children;
  final double? widthPercentage;

  const PageBuilderWidget(
      {required this.id,
      required this.elementType,
      required this.properties,
      required this.children,
      required this.widthPercentage});

  PageBuilderWidget copyWith(
      {UniqueID? id,
      PageBuilderWidgetType? elementType,
      PageBuilderProperties? properties,
      List<PageBuilderWidget>? children,
      double? widthPercentage}) {
    return PageBuilderWidget(
        id: id ?? this.id,
        elementType: elementType ?? this.elementType,
        properties: properties ?? this.properties,
        children: children ?? this.children,
        widthPercentage: widthPercentage ?? this.widthPercentage);
  }

  @override
  List<Object?> get props =>
      [id, elementType, properties, children, widthPercentage];
}
