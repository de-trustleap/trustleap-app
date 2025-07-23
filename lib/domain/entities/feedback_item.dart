// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class FeedbackItem extends Equatable {
  final UniqueID id;
  final String? title;
  final String? description;
  final List<String>? downloadImageUrls;
  final List<String>? thumbnailDownloadURLs;
  final String? userAgent;
  final DateTime? createdAt;

  const FeedbackItem(
      {required this.id,
      required this.title,
      required this.description,
      this.downloadImageUrls,
      this.thumbnailDownloadURLs,
      this.userAgent,
      this.createdAt});

  FeedbackItem copyWith(
      {UniqueID? id,
      String? title,
      String? description,
      List<String>? downloadImageUrls,
      List<String>? thumbnailDownloadURLs,
      String? userAgent,
      DateTime? createdAt}) {
    return FeedbackItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        downloadImageUrls: downloadImageUrls ?? this.downloadImageUrls,
        thumbnailDownloadURLs:
            thumbnailDownloadURLs ?? this.thumbnailDownloadURLs,
        userAgent: userAgent ?? this.userAgent,
        createdAt: createdAt ?? this.createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        downloadImageUrls,
        thumbnailDownloadURLs,
        userAgent,
        createdAt
      ];
}
