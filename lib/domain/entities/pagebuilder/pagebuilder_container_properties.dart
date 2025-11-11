// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderContainerProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderBorder? border;
  final PageBuilderShadow? shadow;

  const PageBuilderContainerProperties(
      {required this.border, required this.shadow});

  PageBuilderContainerProperties copyWith({
    PagebuilderBorder? border,
    PageBuilderShadow? shadow,
  }) {
    return PageBuilderContainerProperties(
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
    );
  }

  PageBuilderContainerProperties deepCopy() {
    return PageBuilderContainerProperties(
      border: border?.deepCopy(),
      shadow: shadow?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [border, shadow];
}
