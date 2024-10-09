// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderTextFieldProperties extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final PageBuilderTextProperties? placeHolderTextProperties;
  final PageBuilderTextProperties? textProperties;

  const PageBuilderTextFieldProperties({
    required this.width,
    required this.height,
    required this.placeHolderTextProperties,
    required this.textProperties,
  });

  PageBuilderTextFieldProperties copyWith(
      {double? width,
      double? height,
      PageBuilderTextProperties? placeHolderTextProperties,
      PageBuilderTextProperties? textProperties}) {
    return PageBuilderTextFieldProperties(
      width: width ?? this.width,
      height: height ?? this.height,
      placeHolderTextProperties:
          placeHolderTextProperties ?? this.placeHolderTextProperties,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  @override
  List<Object?> get props =>
      [width, height, placeHolderTextProperties, textProperties];
}

//TODO: Alle Properties wurden angelegt. Jetzt Kontaktformular bauen.