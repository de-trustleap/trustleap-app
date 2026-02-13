// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_fonts.dart';

class PageBuilderGlobalFontsModel extends Equatable {
  final String? headline;
  final String? text;

  const PageBuilderGlobalFontsModel({
    required this.headline,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (headline != null) map['headline'] = headline;
    if (text != null) map['text'] = text;
    return map;
  }

  factory PageBuilderGlobalFontsModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderGlobalFontsModel(
      headline: map['headline'] as String?,
      text: map['text'] as String?,
    );
  }

  PageBuilderGlobalFontsModel copyWith({
    String? headline,
    String? text,
  }) {
    return PageBuilderGlobalFontsModel(
      headline: headline ?? this.headline,
      text: text ?? this.text,
    );
  }

  PageBuilderGlobalFonts toDomain() {
    return PageBuilderGlobalFonts(
      headline: headline,
      text: text,
    );
  }

  factory PageBuilderGlobalFontsModel.fromDomain(
      PageBuilderGlobalFonts fonts) {
    return PageBuilderGlobalFontsModel(
      headline: fonts.headline,
      text: fonts.text,
    );
  }

  @override
  List<Object?> get props => [headline, text];
}
