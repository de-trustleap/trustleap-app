// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

class PageBuilderContainerProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderBorder? border;
  final PageBuilderShadow? shadow;
  final PagebuilderResponsiveOrConstant<double>? width;
  final PagebuilderResponsiveOrConstant<double>? height;

  const PageBuilderContainerProperties({
    required this.border,
    required this.shadow,
    required this.width,
    required this.height,
  });

  PageBuilderContainerProperties copyWith({
    PagebuilderBorder? border,
    PageBuilderShadow? shadow,
    PagebuilderResponsiveOrConstant<double>? width,
    PagebuilderResponsiveOrConstant<double>? height,
    bool removeWidth = false,
    bool removeHeight = false,
  }) {
    return PageBuilderContainerProperties(
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      width: removeWidth ? null : (width ?? this.width),
      height: removeHeight ? null : (height ?? this.height),
    );
  }

  PageBuilderContainerProperties deepCopy() {
    return PageBuilderContainerProperties(
      border: border?.deepCopy(),
      shadow: shadow?.deepCopy(),
      width: width?.deepCopy(),
      height: height?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [border, shadow, width, height];
}
