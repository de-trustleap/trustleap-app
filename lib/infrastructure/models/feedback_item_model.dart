// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class FeedbackItemModel extends Equatable {
  final String id;
  final String? email;
  final String? title;
  final String? description;
  final String? type;
  final List<String>? downloadImageUrls;
  final List<String>? thumbnailDownloadURLs;
  final String? userAgent;
  final dynamic createdAt;

  const FeedbackItemModel(
      {required this.id,
      this.email,
      required this.title,
      required this.description,
      required this.type,
      this.downloadImageUrls,
      this.thumbnailDownloadURLs,
      this.userAgent,
      this.createdAt});

  FeedbackItemModel copyWith(
      {String? id,
      String? email,
      String? title,
      String? description,
      String? type,
      List<String>? downloadImageUrls,
      List<String>? thumbnailDownloadURLs,
      String? userAgent,
      dynamic createdAt}) {
    return FeedbackItemModel(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'title': title,
      'description': description,
      'type': type,
      'downloadImageUrls': downloadImageUrls,
      'thumbnailDownloadURLs': thumbnailDownloadURLs,
      'userAgent': userAgent,
      'createdAt': createdAt
    };
  }

  factory FeedbackItemModel.fromMap(Map<String, dynamic> map) {
    return FeedbackItemModel(
        id: "",
        email: map['email'] != null ? map['email'] as String : null,
        title: map['title'] != null ? map['title'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        type: map['type'] != null ? map['type'] as String : null,
        downloadImageUrls: map['downloadImageUrls'] != null
            ? (map['downloadImageUrls'] as List).whereType<String>().toList()
            : null,
        thumbnailDownloadURLs: (map['thumbnailDownloadURLs'] != null
            ? (map['thumbnailDownloadURLs'] as List)
                .whereType<String>()
                .toList()
            : null),
        userAgent: map['userAgent'] != null ? map['userAgent'] as String : null,
        createdAt: map['createdAt'] as dynamic);
  }

  factory FeedbackItemModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return FeedbackItemModel.fromMap(doc).copyWith(id: id);
  }

  FeedbackItem toDomain() {
    return FeedbackItem(
        id: UniqueID.fromUniqueString(id),
        email: email,
        title: title,
        description: description,
        type: type != null
            ? FeedbackType.values.firstWhere((t) => t.value == type)
            : null,
        downloadImageUrls: downloadImageUrls,
        thumbnailDownloadURLs: thumbnailDownloadURLs,
        userAgent: userAgent,
        createdAt: (createdAt as Timestamp).toDate());
  }

  factory FeedbackItemModel.fromDomain(FeedbackItem feedback) {
    return FeedbackItemModel(
        id: feedback.id.value,
        email: feedback.email,
        title: feedback.title,
        description: feedback.description,
        type: feedback.type?.value,
        downloadImageUrls: feedback.downloadImageUrls,
        thumbnailDownloadURLs: feedback.thumbnailDownloadURLs,
        userAgent: feedback.userAgent,
        createdAt: FieldValue.serverTimestamp());
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
