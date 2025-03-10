// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class LandingPage extends Equatable {
  final UniqueID id;
  final String? name;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;
  final UniqueID? ownerID;
  final UniqueID? contentID;
  final String? description;
  final String? promotionTemplate;
  final List<String>? associatedUsersIDs;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;
  final bool? isDefaultPage;
  final bool? isActive;
  final String? impressum;
  final String? privacyPolicy;
  final String? initialInformation;
  final String? termsAndConditions;
  final String? scriptTags;

  const LandingPage(
      {required this.id,
      this.name,
      this.downloadImageUrl,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.contentID,
      this.description,
      this.promotionTemplate,
      this.associatedUsersIDs,
      this.createdAt,
      this.lastUpdatedAt,
      this.isDefaultPage,
      this.isActive,
      this.impressum,
      this.privacyPolicy,
      this.initialInformation,
      this.termsAndConditions,
      this.scriptTags});

  LandingPage copyWith(
      {UniqueID? id,
      String? name,
      String? downloadImageUrl,
      String? thumbnailDownloadURL,
      UniqueID? ownerID,
      UniqueID? contentID,
      String? description,
      String? promotionTemplate,
      List<String>? associatedUsersIDs,
      DateTime? createdAt,
      DateTime? lastUpdatedAt,
      bool? isDefaultPage,
      bool? isActive,
      String? impressum,
      String? privacyPolicy,
      String? initialInformation,
      String? termsAndConditions,
      String? scriptTags}) {
    return LandingPage(
        id: id ?? this.id,
        name: name ?? this.name,
        downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        contentID: contentID ?? this.contentID,
        description: description ?? this.description,
        promotionTemplate: promotionTemplate ?? this.promotionTemplate,
        associatedUsersIDs: associatedUsersIDs ?? this.associatedUsersIDs,
        createdAt: createdAt ?? this.createdAt,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        isDefaultPage: isDefaultPage ?? this.isDefaultPage,
        isActive: isActive ?? this.isActive,
        impressum: impressum ?? this.impressum,
        privacyPolicy: privacyPolicy ?? this.privacyPolicy,
        initialInformation: initialInformation ?? this.initialInformation,
        termsAndConditions: termsAndConditions ?? this.termsAndConditions,
        scriptTags: scriptTags ?? this.scriptTags);
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
        isActive,
        impressum,
        privacyPolicy,
        initialInformation,
        termsAndConditions,
        scriptTags
      ];
}
