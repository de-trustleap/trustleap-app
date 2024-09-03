// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

abstract class PageBuilderProperties {}

class PageBuilderWidget extends Equatable {
  final UniqueID id;
  final PageBuilderWidgetType? elementType;
  //final List<PageBuilderWidget>? children;
  final PageBuilderProperties? properties;

  const PageBuilderWidget({
    required this.id,
    required this.elementType,
    required this.properties,
  });

  PageBuilderWidget copyWith({
    UniqueID? id,
    PageBuilderWidgetType? elementType,
    PageBuilderProperties? properties,
  }) {
    return PageBuilderWidget(
      id: id ?? this.id,
      elementType: elementType ?? this.elementType,
      properties: properties ?? this.properties,
    );
  }

  @override
  List<Object?> get props => [id, elementType, properties];
}
