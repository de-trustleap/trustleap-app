// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';

class PageBuilderPage extends Equatable {
  final UniqueID id;
  final List<PageBuilderSection>? sections;

  const PageBuilderPage({
    required this.id,
    required this.sections,
  });

  PageBuilderPage copyWith({
    UniqueID? id,
    List<PageBuilderSection>? sections,
  }) {
    return PageBuilderPage(
      id: id ?? this.id,
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [id];
}
