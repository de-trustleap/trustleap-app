// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderSection extends Equatable {
  final UniqueID id;
  final PageBuilderSectionLayout? layout;
  final PagebuilderBackground? background;
  final double? maxWidth;
  final List<PageBuilderWidget>? widgets;

  const PageBuilderSection(
      {required this.id,
      required this.layout,
      required this.widgets,
      required this.background,
      required this.maxWidth});

  PageBuilderSection copyWith(
      {UniqueID? id,
      PageBuilderSectionLayout? layout,
      List<PageBuilderWidget>? widgets,
      PagebuilderBackground? background,
      double? maxWidth}) {
    return PageBuilderSection(
        id: id ?? this.id,
        layout: layout ?? this.layout,
        widgets: widgets ?? this.widgets,
        background: background ?? this.background,
        maxWidth: maxWidth ?? this.maxWidth);
  }

  @override
  List<Object?> get props => [id, layout, background, maxWidth, widgets];
}
