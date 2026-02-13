import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';

class PagebuilderSectionTemplateMeta extends Equatable {
  final String id;
  final SectionType type;
  final String thumbnailUrl;

  const PagebuilderSectionTemplateMeta({
    required this.id,
    required this.type,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, type, thumbnailUrl];
}
