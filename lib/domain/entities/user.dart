// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class CustomUser extends Equatable {
  final UniqueID id;
  final Gender? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? address;
  final String? postCode;
  final String? place;
  final String? email;
  final String? parentUserID;
  final String? companyID;
  final Role? role;
  final String? profileImageDownloadURL;
  final String? thumbnailDownloadURL;
  final String? pendingCompanyRequestID;
  final String? defaultLandingPageID;
  final List<String>? unregisteredPromoterIDs;
  final List<String>? registeredPromoterIDs;
  final List<String>? landingPageIDs;
  final List<String>? recommendationIDs;
  final List<String>? favoriteRecommendationIDs;
  final List<String>? archivedRecommendationIDs;
  final DateTime? deletesAt;
  final DateTime? lastUpdated;
  final DateTime? createdAt;

  const CustomUser(
      {required this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.address,
      this.postCode,
      this.place,
      this.email,
      this.parentUserID,
      this.companyID,
      this.role,
      this.profileImageDownloadURL,
      this.thumbnailDownloadURL,
      this.pendingCompanyRequestID,
      this.defaultLandingPageID,
      this.unregisteredPromoterIDs,
      this.registeredPromoterIDs,
      this.landingPageIDs,
      this.recommendationIDs,
      this.favoriteRecommendationIDs,
      this.archivedRecommendationIDs,
      this.deletesAt,
      this.lastUpdated,
      this.createdAt});

  CustomUser copyWith(
      {UniqueID? id,
      Gender? gender,
      String? firstName,
      String? lastName,
      String? birthDate,
      String? address,
      String? postCode,
      String? place,
      String? email,
      String? parentUserID,
      String? companyID,
      Role? role,
      String? profileImageDownloadURL,
      String? thumbnailDownloadURL,
      String? pendingCompanyRequestID,
      String? defaultLandingPageID,
      List<String>? unregisteredPromoterIDs,
      List<String>? registeredPromoterIDs,
      List<String>? landingPageIDs,
      List<String>? recommendationIDs,
      List<String>? favoriteRecommendationIDs,
      List<String>? archivedRecommendationIDs,
      DateTime? deletesAt,
      DateTime? lastUpdated,
      DateTime? createdAt}) {
    return CustomUser(
        id: id ?? this.id,
        gender: gender ?? this.gender,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthDate: birthDate ?? this.birthDate,
        address: address ?? this.address,
        postCode: postCode ?? this.postCode,
        place: place ?? this.place,
        email: email ?? this.email,
        parentUserID: parentUserID ?? this.parentUserID,
        companyID: companyID ?? this.companyID,
        role: role ?? this.role,
        profileImageDownloadURL:
            profileImageDownloadURL ?? this.profileImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        pendingCompanyRequestID:
            pendingCompanyRequestID ?? this.pendingCompanyRequestID,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        unregisteredPromoterIDs:
            unregisteredPromoterIDs ?? this.unregisteredPromoterIDs,
        registeredPromoterIDs:
            registeredPromoterIDs ?? this.registeredPromoterIDs,
        landingPageIDs: landingPageIDs ?? this.landingPageIDs,
        recommendationIDs: recommendationIDs ?? this.recommendationIDs,
        favoriteRecommendationIDs:
            favoriteRecommendationIDs ?? this.favoriteRecommendationIDs,
        archivedRecommendationIDs:
            archivedRecommendationIDs ?? this.archivedRecommendationIDs,
        deletesAt: deletesAt ?? this.deletesAt,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        createdAt: createdAt ?? this.createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        gender,
        firstName,
        lastName,
        birthDate,
        address,
        postCode,
        place,
        email,
        parentUserID,
        role,
        profileImageDownloadURL,
        thumbnailDownloadURL,
        unregisteredPromoterIDs,
        registeredPromoterIDs,
        landingPageIDs,
        recommendationIDs,
        favoriteRecommendationIDs,
        archivedRecommendationIDs
      ];
}
