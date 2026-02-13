// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';

class LandingPageTemplate extends Equatable {
  final UniqueID id;
  final String? name;
  final String? thumbnailDownloadURL;
  final PageBuilderPage? page;

  const LandingPageTemplate({
    required this.id,
    required this.name,
    required this.thumbnailDownloadURL,
    required this.page,
  });

  LandingPageTemplate copyWith({
    UniqueID? id,
    String? name,
    String? thumbnailDownloadURL,
    PageBuilderPage? page,
  }) {
    return LandingPageTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [id, name, thumbnailDownloadURL, page];
}
