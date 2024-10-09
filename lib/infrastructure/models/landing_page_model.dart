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
  final String? contentID;
  final String? description;
  final String? promotionTemplate;
  final List<String>? associatedUsersIDs;
  final DateTime? lastUpdatedAt;
  final dynamic createdAt;
  final bool? isDefaultPage;
  final bool? isActive;

  const LandingPageModel(
      {required this.id,
      this.name,
      this.downloadImageUrl,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.contentID,
      this.description,
      this.promotionTemplate,
      this.associatedUsersIDs,
      this.lastUpdatedAt,
      required this.createdAt,
      this.isDefaultPage,
      this.isActive});

  LandingPageModel copyWith(
      {String? id,
      String? name,
      String? downloadImageUrl,
      String? thumbnailDownloadURL,
      String? ownerID,
      String? contentID,
      String? description,
      String? promotionTemplate,
      List<String>? associatedUsersIDs,
      DateTime? lastUpdatedAt,
      dynamic createdAt,
      bool? isDefaultPage,
      bool? isActive}) {
    return LandingPageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        contentID: contentID ?? this.contentID,
        description: description ?? this.description,
        promotionTemplate: promotionTemplate ?? this.promotionTemplate,
        associatedUsersIDs: associatedUsersIDs ?? this.associatedUsersIDs,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        createdAt: createdAt ?? this.createdAt,
        isDefaultPage: isDefaultPage ?? this.isDefaultPage,
        isActive: isActive ?? this.isActive);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'downloadImageUrl': downloadImageUrl,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'ownerID': ownerID,
      'contentID': contentID,
      'description': description,
      'promotionTemplate': promotionTemplate,
      'associatedUsersIDs': associatedUsersIDs,
      'lastUpdatedAt': lastUpdatedAt,
      'createdAt': createdAt,
      'isDefaultPage': isDefaultPage,
      'isActive': isActive
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
        contentID: map['contentID'] != null ? map['contentID'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        promotionTemplate: map['promotionTemplate'] != null
            ? map['promotionTemplate'] as String
            : null,
        associatedUsersIDs: map['associatedUsersIDs'] != null
            ? List<String>.from(map['associatedUsersIDs'])
            : null,
        lastUpdatedAt: map['lastUpdatedAt'] != null
            ? (map['lastUpdatedAt'] as Timestamp).toDate()
            : null,
        createdAt: map['createdAt'] as dynamic,
        isDefaultPage: map['isDefaultPage'] != null
            ? map['isDefaultPage'] as bool
            : false,
        isActive: map['isActive'] != null
            ? map['isActive'] as bool
            : null);
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
        ownerID: ownerID != null ? UniqueID.fromUniqueString(ownerID!) : null,
        contentID: contentID != null ? UniqueID.fromUniqueString(contentID!) : null,
        description: description,
        promotionTemplate: promotionTemplate,
        associatedUsersIDs: associatedUsersIDs,
        lastUpdatedAt: lastUpdatedAt,
        createdAt: (createdAt as Timestamp).toDate(),
        isDefaultPage: isDefaultPage ?? false,
        isActive: isActive);
  }

  factory LandingPageModel.fromDomain(LandingPage landingPage) {
    return LandingPageModel(
        id: landingPage.id.value,
        name: landingPage.name,
        downloadImageUrl: landingPage.downloadImageUrl,
        thumbnailDownloadURL: landingPage.thumbnailDownloadURL,
        ownerID: landingPage.ownerID?.value,
        contentID: landingPage.contentID?.value,
        description: landingPage.description,
        promotionTemplate: landingPage.promotionTemplate,
        associatedUsersIDs: landingPage.associatedUsersIDs,
        lastUpdatedAt: landingPage.lastUpdatedAt,
        createdAt: FieldValue.serverTimestamp(),
        isDefaultPage: landingPage.isDefaultPage,
        isActive: landingPage.isActive);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        downloadImageUrl,
        thumbnailDownloadURL,
        ownerID,
        contentID,
        description,
        promotionTemplate,
        isDefaultPage,
        isActive
      ];
}
