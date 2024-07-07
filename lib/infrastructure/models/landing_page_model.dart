// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';

class LandingPageModel extends Equatable {
  final String id;
  final String? name;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;
  final String? ownerID;
  final String? text;
  final DateTime? lastUpdatedAt;
  final dynamic createdAt;

  const LandingPageModel(
      {required this.id,
      this.name,
      this.downloadImageUrl,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.text,
      this.lastUpdatedAt,
      required this.createdAt});

  LandingPageModel copyWith(
      {String? id,
      String? name,
      String? downloadImageUrl,
      String? thumbnailDownloadURL,
      String? ownerID,
      String? text,
      DateTime? lastUpdatedAt,
      dynamic createdAt}) {
    return LandingPageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        text: text ?? this.text,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'downloadImageUrl': downloadImageUrl,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'ownerID': ownerID,
      'text': text,
      'lastUpdatedAt': lastUpdatedAt,
      'createdAt': createdAt
    };
  }

  factory LandingPageModel.fromMap(Map<String, dynamic> map) {
    return LandingPageModel(
        id: "",
        name: map['name'] != null ? map['name'] as String : null,
        downloadImageUrl: map['downloadImageUrl'] != null
            ? map['downloadImageUrl'] as String
            : null,
        thumbnailDownloadURL: map['thumbnailDownloadURL'] != null
            ? map['thumbnailDownloadURL'] as String
            : null,
        ownerID: map['ownerID'] != null ? map['ownerID'] as String : null,
        text: map['text'] != null ? map['text'] as String : null,
        lastUpdatedAt: map['lastUpdatedAt'] != null
            ? (map['lastUpdatedAt'] as Timestamp).toDate()
            : null,
        createdAt: map['createdAt'] as dynamic);
  }

  factory LandingPageModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return LandingPageModel.fromMap(doc).copyWith(id: id);
  }

  LandingPage toDomain() {
    return LandingPage(
        id: UniqueID.fromUniqueString(id),
        name: name,
        downloadImageUrl: downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL,
        ownerID: UniqueID.fromUniqueString(ownerID ?? ""),
        text: text,
        lastUpdatedAt: lastUpdatedAt,
        createdAt: (createdAt as Timestamp).toDate());
  }

  factory LandingPageModel.fromDomain(LandingPage landingPage) {
    return LandingPageModel(
        id: landingPage.id.value,
        name: landingPage.name,
        downloadImageUrl: landingPage.downloadImageUrl,
        thumbnailDownloadURL: landingPage.thumbnailDownloadURL,
        ownerID: landingPage.ownerID?.value ?? "",
        text: landingPage.text,
        lastUpdatedAt: landingPage.lastUpdatedAt,
        createdAt: FieldValue.serverTimestamp());
  }

  @override
  List<Object?> get props =>
      [id, name, downloadImageUrl, thumbnailDownloadURL, ownerID, text];
}
