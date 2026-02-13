// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_background.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';

class PageBuilderSection extends Equatable {
  final UniqueID id;
  final String? name;
  final PagebuilderBackground? background;
  final double? maxWidth;
  final bool? backgroundConstrained;
  final String? customCSS;
  final PagebuilderResponsiveOrConstant<bool>? fullHeight;
  final List<PageBuilderWidget>? widgets;
  final List<PagebuilderResponsiveBreakpoint>? visibleOn;

  const PageBuilderSection(
      {required this.id,
      required this.name,
      required this.widgets,
      required this.background,
      required this.maxWidth,
      required this.backgroundConstrained,
      required this.customCSS,
      required this.fullHeight,
      required this.visibleOn});

  PageBuilderSection copyWith({
    UniqueID? id,
    String? name,
    List<PageBuilderWidget>? widgets,
    PagebuilderBackground? background,
    double? maxWidth,
    bool? backgroundConstrained,
    String? customCSS,
    PagebuilderResponsiveOrConstant<bool>? fullHeight,
    List<PagebuilderResponsiveBreakpoint>? visibleOn,
    bool updateVisibleOn = false,
  }) {
    return PageBuilderSection(
        id: id ?? this.id,
        name: name ?? this.name,
        widgets: widgets ?? this.widgets,
        background: background ?? this.background,
        maxWidth: maxWidth ?? this.maxWidth,
        backgroundConstrained:
            backgroundConstrained ?? this.backgroundConstrained,
        customCSS: customCSS ?? this.customCSS,
        fullHeight: fullHeight ?? this.fullHeight,
        visibleOn: updateVisibleOn ? visibleOn : (visibleOn ?? this.visibleOn));
  }

  @override
  List<Object?> get props => [
        id,
        name,
        background,
        maxWidth,
        backgroundConstrained,
        customCSS,
        fullHeight,
        widgets,
        visibleOn
      ];
}
