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
  final List<String>? associatedUsersIDs;
  final DateTime? lastUpdatedAt;
  final dynamic createdAt;
  final bool? isDefaultPage;

  const LandingPageModel(
      {required this.id,
      this.name,
      this.downloadImageUrl,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.text,
      this.associatedUsersIDs,
      this.lastUpdatedAt,
      required this.createdAt,
      this.isDefaultPage});

  LandingPageModel copyWith(
      {String? id,
      String? name,
      String? downloadImageUrl,
      String? thumbnailDownloadURL,
      String? ownerID,
      String? text,
      List<String>? associatedUsersIDs,
      DateTime? lastUpdatedAt,
      dynamic createdAt,
      bool? isDefaultPage}) {
    return LandingPageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        text: text ?? this.text,
        associatedUsersIDs: associatedUsersIDs ?? this.associatedUsersIDs,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        createdAt: createdAt ?? this.createdAt,
        isDefaultPage: isDefaultPage ?? this.isDefaultPage);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'downloadImageUrl': downloadImageUrl,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'ownerID': ownerID,
      'text': text,
      'associatedUsersIDs': associatedUsersIDs,
      'lastUpdatedAt': lastUpdatedAt,
      'createdAt': createdAt,
      'isDefaultPage': isDefaultPage
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
        associatedUsersIDs: map['associatedUsersIDs'] != null
            ? List<String>.from(map['associatedUsersIDs'])
            : null,
        lastUpdatedAt: map['lastUpdatedAt'] != null
            ? (map['lastUpdatedAt'] as Timestamp).toDate()
            : null,
        createdAt: map['createdAt'] as dynamic,
        isDefaultPage: map['isDefaultPage'] != null ? map['isDefaultPage'] as bool : false
        );
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
        associatedUsersIDs: associatedUsersIDs,
        lastUpdatedAt: lastUpdatedAt,
        createdAt: (createdAt as Timestamp).toDate(),
        isDefaultPage: isDefaultPage ?? false
        );
  }

  factory LandingPageModel.fromDomain(LandingPage landingPage) {
    return LandingPageModel(
        id: landingPage.id.value,
        name: landingPage.name,
        downloadImageUrl: landingPage.downloadImageUrl,
        thumbnailDownloadURL: landingPage.thumbnailDownloadURL,
        ownerID: landingPage.ownerID?.value ?? "",
        text: landingPage.text,
        associatedUsersIDs: landingPage.associatedUsersIDs,
        lastUpdatedAt: landingPage.lastUpdatedAt,
        createdAt: FieldValue.serverTimestamp(),
        isDefaultPage: landingPage.isDefaultPage
        );
  }

  @override
  List<Object?> get props =>
      [id, name, downloadImageUrl, thumbnailDownloadURL, ownerID, text];
}
