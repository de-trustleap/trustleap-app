// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderContainerProperties extends Equatable implements PageBuilderProperties {
  final double? borderRadius;
  final PageBuilderShadow? shadow;

  const PageBuilderContainerProperties({
    required this.borderRadius,
    required this.shadow
  });

  PageBuilderContainerProperties copyWith({
    double? borderRadius,
    PageBuilderShadow? shadow,
  }) {
    return PageBuilderContainerProperties(
      borderRadius: borderRadius ?? this.borderRadius,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  List<Object?> get props => [borderRadius, shadow];
}
