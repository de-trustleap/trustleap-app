// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PageBuilderGlobalFonts extends Equatable {
  final String? headline;
  final String? text;

  const PageBuilderGlobalFonts({
    required this.headline,
    required this.text,
  });

  PageBuilderGlobalFonts copyWith({
    String? headline,
    String? text,
  }) {
    return PageBuilderGlobalFonts(
      headline: headline ?? this.headline,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [headline, text];
}
