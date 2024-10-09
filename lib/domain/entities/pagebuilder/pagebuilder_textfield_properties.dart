// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderTextFieldProperties extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final int? maxLines;
  final bool? isRequired;
  final PageBuilderTextProperties? placeHolderTextProperties;
  final PageBuilderTextProperties? textProperties;

  const PageBuilderTextFieldProperties({
    required this.width,
    required this.maxLines,
    required this.isRequired,
    required this.placeHolderTextProperties,
    required this.textProperties,
  });

  PageBuilderTextFieldProperties copyWith(
      {double? width,
      int? maxLines,
      bool? isRequired,
      PageBuilderTextProperties? placeHolderTextProperties,
      PageBuilderTextProperties? textProperties}) {
    return PageBuilderTextFieldProperties(
      width: width ?? this.width,
      maxLines: maxLines ?? this.maxLines,
      isRequired: isRequired ?? this.isRequired,
      placeHolderTextProperties:
          placeHolderTextProperties ?? this.placeHolderTextProperties,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  @override
  List<Object?> get props =>
      [width, maxLines, isRequired, placeHolderTextProperties, textProperties];
}
