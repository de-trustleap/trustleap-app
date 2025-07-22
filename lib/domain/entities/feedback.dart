// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class Feedback extends Equatable {
  final UniqueID id;
  final String? title;
  final String? description;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;

  const Feedback({
    required this.id,
    required this.title,
    required this.description,
    this.downloadImageUrl,
    this.thumbnailDownloadURL,
  });

  Feedback copyWith({
    UniqueID? id,
    String? title,
    String? description,
    String? downloadImageUrl,
    String? thumbnailDownloadURL,
  }) {
    return Feedback(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
      thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, downloadImageUrl, thumbnailDownloadURL];
}
