// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_global_colors_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_global_fonts_model.dart';

class PageBuilderGlobalStylesModel extends Equatable {
  final PageBuilderGlobalColorsModel? colors;
  final PageBuilderGlobalFontsModel? fonts;

  const PageBuilderGlobalStylesModel({
    required this.colors,
    required this.fonts,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (colors != null) map['colors'] = colors!.toMap();
    if (fonts != null) map['fonts'] = fonts!.toMap();
    return map;
  }

  factory PageBuilderGlobalStylesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderGlobalStylesModel(
      colors: map['colors'] != null
          ? PageBuilderGlobalColorsModel.fromMap(map['colors'] as Map<String, dynamic>)
          : null,
      fonts: map['fonts'] != null
          ? PageBuilderGlobalFontsModel.fromMap(map['fonts'] as Map<String, dynamic>)
          : null,
    );
  }

  PageBuilderGlobalStylesModel copyWith({
    PageBuilderGlobalColorsModel? colors,
    PageBuilderGlobalFontsModel? fonts,
  }) {
    return PageBuilderGlobalStylesModel(
      colors: colors ?? this.colors,
      fonts: fonts ?? this.fonts,
    );
  }

  PageBuilderGlobalStyles toDomain() {
    return PageBuilderGlobalStyles(
      colors: colors?.toDomain(),
      fonts: fonts?.toDomain(),
    );
  }

  factory PageBuilderGlobalStylesModel.fromDomain(
      PageBuilderGlobalStyles styles) {
    return PageBuilderGlobalStylesModel(
      colors: styles.colors != null
          ? PageBuilderGlobalColorsModel.fromDomain(styles.colors!)
          : null,
      fonts: styles.fonts != null
          ? PageBuilderGlobalFontsModel.fromDomain(styles.fonts!)
          : null,
    );
  }

  @override
  List<Object?> get props => [colors, fonts];
}
