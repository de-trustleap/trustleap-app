// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class FeedbackItem extends Equatable {
  final UniqueID id;
  final String? email;
  final String? title;
  final String? description;
  final FeedbackType? type;
  final List<String>? downloadImageUrls;
  final List<String>? thumbnailDownloadURLs;
  final String? userAgent;
  final DateTime? createdAt;

  const FeedbackItem(
      {required this.id,
      this.email,
      required this.title,
      required this.description,
      required this.type,
      this.downloadImageUrls,
      this.thumbnailDownloadURLs,
      this.userAgent,
      this.createdAt});

  FeedbackItem copyWith(
      {UniqueID? id,
      String? email,
      String? title,
      String? description,
      FeedbackType? type,
      List<String>? downloadImageUrls,
      List<String>? thumbnailDownloadURLs,
      String? userAgent,
      DateTime? createdAt}) {
    return FeedbackItem(
        id: id ?? this.id,
        email: email ?? this.email,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        downloadImageUrls: downloadImageUrls ?? this.downloadImageUrls,
        thumbnailDownloadURLs:
            thumbnailDownloadURLs ?? this.thumbnailDownloadURLs,
        userAgent: userAgent ?? this.userAgent,
        createdAt: createdAt ?? this.createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        email,
        title,
        description,
        type,
        downloadImageUrls,
        thumbnailDownloadURLs,
        userAgent,
        createdAt
      ];
}
