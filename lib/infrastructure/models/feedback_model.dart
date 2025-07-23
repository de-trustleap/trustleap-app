// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/feedback.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class FeedbackModel extends Equatable {
  final String id;
  final String? title;
  final String? description;
  final List<String>? downloadImageUrls;
  final List<String>? thumbnailDownloadURLs;
  final String? userAgent;
  final dynamic createdAt;

  const FeedbackModel(
      {required this.id,
      required this.title,
      required this.description,
      this.downloadImageUrls,
      this.thumbnailDownloadURLs,
      this.userAgent,
      this.createdAt});

  FeedbackModel copyWith(
      {String? id,
      String? title,
      String? description,
      List<String>? downloadImageUrls,
      List<String>? thumbnailDownloadURLs,
      String? userAgent,
      dynamic createdAt}) {
    return FeedbackModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        downloadImageUrls: downloadImageUrls ?? this.downloadImageUrls,
        thumbnailDownloadURLs:
            thumbnailDownloadURLs ?? this.thumbnailDownloadURLs,
        userAgent: userAgent ?? this.userAgent,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'downloadImageUrls': downloadImageUrls,
      'thumbnailDownloadURLs': thumbnailDownloadURLs,
      'userAgent': userAgent,
      'createdAt': createdAt
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
        id: "",
        title: map['title'] != null ? map['title'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        downloadImageUrls: map['downloadImageUrls'] != null
            ? map['downloadImageUrls'] as List<String>
            : null,
        thumbnailDownloadURLs: (map['thumbnailDownloadURLs'] != null
            ? map['thumbnailDownloadURLs'] as List<String>
            : null),
        userAgent: map['userAgent'] != null ? map['userAgent'] as String : null,
        createdAt: map['createdAt'] as dynamic);
  }

  factory FeedbackModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return FeedbackModel.fromMap(doc).copyWith(id: id);
  }

  Feedback toDomain() {
    return Feedback(
        id: UniqueID.fromUniqueString(id),
        title: title,
        description: description,
        downloadImageUrls: downloadImageUrls,
        thumbnailDownloadURLs: thumbnailDownloadURLs,
        userAgent: userAgent,
        createdAt: (createdAt as Timestamp).toDate());
  }

  factory FeedbackModel.fromDomain(Feedback feedback) {
    return FeedbackModel(
        id: feedback.id.value,
        title: feedback.title,
        description: feedback.description,
        downloadImageUrls: feedback.downloadImageUrls,
        thumbnailDownloadURLs: feedback.thumbnailDownloadURLs,
        userAgent: feedback.userAgent,
        createdAt: FieldValue.serverTimestamp());
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
