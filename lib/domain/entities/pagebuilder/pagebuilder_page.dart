// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:flutter/material.dart';

class PageBuilderPage extends Equatable {
  final UniqueID id;
  final List<PageBuilderSection>? sections;
  final Color? backgroundColor;
  final String? globalBackgroundColorToken;
  final PageBuilderGlobalStyles? globalStyles;

  const PageBuilderPage({
    required this.id,
    required this.sections,
    required this.backgroundColor,
    this.globalBackgroundColorToken,
    required this.globalStyles,
  });

  PageBuilderPage copyWith({
    UniqueID? id,
    List<PageBuilderSection>? sections,
    Color? backgroundColor,
    String? globalBackgroundColorToken,
    PageBuilderGlobalStyles? globalStyles,
  }) {
    return PageBuilderPage(
      id: id ?? this.id,
      sections: sections ?? this.sections,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      globalBackgroundColorToken: globalBackgroundColorToken ?? this.globalBackgroundColorToken,
      globalStyles: globalStyles ?? this.globalStyles,
    );
  }

  @override
  List<Object?> get props => [id, sections, backgroundColor, globalBackgroundColorToken, globalStyles];
}
