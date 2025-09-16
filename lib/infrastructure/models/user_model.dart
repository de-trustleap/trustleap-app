// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? address;
  final String? postCode;
  final String? place;
  final String? email;
  final String? parentUserID;
  final String? companyID;
  final String? profileImageDownloadURL;
  final String? thumbnailDownloadURL;
  final String? pendingCompanyRequestID;
  final String? defaultLandingPageID;
  final int? tutorialStep;
  final List<String>? unregisteredPromoterIDs;
  final List<String>? registeredPromoterIDs;
  final List<String>? landingPageIDs;
  final List<String>? recommendationIDs;
  final List<String>? favoriteRecommendationIDs;
  final List<String>? archivedRecommendationIDs;
  final int? recommendationCountLast30Days;
  final DateTime? deletesAt;
  final DateTime? lastUpdated;
  final dynamic createdAt;
  final DateTime? recommendationCounterResetAt;

  const UserModel(
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
      this.profileImageDownloadURL,
      this.thumbnailDownloadURL,
      this.pendingCompanyRequestID,
      this.defaultLandingPageID,
      this.unregisteredPromoterIDs,
      this.registeredPromoterIDs,
      this.landingPageIDs,
      this.tutorialStep,
      this.recommendationIDs,
      this.favoriteRecommendationIDs,
      this.archivedRecommendationIDs,
      this.recommendationCountLast30Days,
      this.deletesAt,
      this.lastUpdated,
      this.createdAt,
      this.recommendationCounterResetAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gender': gender,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'address': address,
      'postCode': postCode,
      'place': place,
      'email': email,
      'parentUserID': parentUserID,
      'companyID': companyID,
      'profileImageDownloadURL': profileImageDownloadURL,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'pendingCompanyRequestID': pendingCompanyRequestID,
      'defaultLandingPageID': defaultLandingPageID,
      'unregisteredPromoterIDs': unregisteredPromoterIDs,
      'registeredPromoterIDs': registeredPromoterIDs,
      'landingPageIDs': landingPageIDs,
      'tutorialStep': tutorialStep,
      'recommendationIDs': recommendationIDs,
      'favoriteRecommendationIDs': favoriteRecommendationIDs,
      'archivedRecommendationIDs': archivedRecommendationIDs,
      'recommendationCountLast30Days': recommendationCountLast30Days,
      'deletesAt': deletesAt,
      'lastUpdated': lastUpdated,
      'createdAt': createdAt,
      'recommendationCounterResetAt': recommendationCounterResetAt
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: "",
        gender: map['gender'] != null ? map['gender'] as String : "none",
        firstName: map['firstName'] != null ? map['firstName'] as String : null,
        lastName: map['lastName'] != null ? map['lastName'] as String : null,
        birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
        address: map['address'] != null ? map['address'] as String : null,
        postCode: map['postCode'] != null ? map['postCode'] as String : null,
        place: map['place'] != null ? map['place'] as String : null,
        email: map['email'] != null ? map['email'] as String : null,
        parentUserID:
            map['parentUserID'] != null ? map['parentUserID'] as String : null,
        companyID: map['companyID'] != null ? map['companyID'] as String : null,
        profileImageDownloadURL: map['profileImageDownloadURL'] != null
            ? map['profileImageDownloadURL'] as String
            : null,
        thumbnailDownloadURL: map['thumbnailDownloadURL'] != null
            ? map['thumbnailDownloadURL'] as String
            : null,
        pendingCompanyRequestID: map['pendingCompanyRequestID'] != null
            ? map['pendingCompanyRequestID'] as String
            : null,
        defaultLandingPageID: map['defaultLandingPageID'] != null
            ? map['defaultLandingPageID'] as String
            : null,
        tutorialStep:
            map['tutorialStep'] != null ? map['tutorialStep'] as int : null,
        unregisteredPromoterIDs: map['unregisteredPromoterIDs'] != null
            ? List<String>.from(map['unregisteredPromoterIDs'])
            : null,
        registeredPromoterIDs: map['registeredPromoterIDs'] != null
            ? List<String>.from(map['registeredPromoterIDs'])
            : null,
        landingPageIDs: map['landingPageIDs'] != null
            ? List<String>.from(map['landingPageIDs'])
            : null,
        recommendationIDs: map['recommendationIDs'] != null
            ? List<String>.from(map['recommendationIDs'])
            : null,
        favoriteRecommendationIDs: map['favoriteRecommendationIDs'] != null
            ? List<String>.from(map['favoriteRecommendationIDs'])
            : null,
        archivedRecommendationIDs: map['archivedRecommendationIDs'] != null
            ? List<String>.from(map['archivedRecommendationIDs'])
            : null,
        recommendationCountLast30Days:
            map['recommendationCountLast30Days'] != null
                ? map['recommendationCountLast30Days'] as int
                : null,
        deletesAt: map['deletesAt'] != null
            ? (map['deletesAt'] as Timestamp).toDate()
            : null,
        lastUpdated: map['lastUpdated'] != null
            ? (map['lastUpdated'] as Timestamp).toDate()
            : null,
        createdAt: map['createdAt'] as dynamic,
        recommendationCounterResetAt:
            map['recommendationCounterResetAt'] != null
                ? (map['recommendationCounterResetAt'] as Timestamp).toDate()
                : null);
  }

  UserModel copyWith(
      {String? id,
      String? gender,
      String? firstName,
      String? lastName,
      String? birthDate,
      String? address,
      String? postCode,
      String? place,
      String? email,
      String? parentUserID,
      String? companyID,
      String? profileImageDownloadURL,
      String? thumbnailDownloadURL,
      String? pendingCompanyRequestID,
      String? defaultLandingPageID,
      int? tutorialStep,
      List<String>? unregisteredPromoterIDs,
      List<String>? registeredPromoterIDs,
      List<String>? landingPageIDs,
      List<String>? recommendationIDs,
      List<String>? favoriteRecommendationIDs,
      List<String>? archivedRecommendationIDs,
      int? recommendationCountLast30Days,
      DateTime? deletesAt,
      DateTime? lastUpdated,
      dynamic createdAt,
      DateTime? recommendationCounterResetAt}) {
    return UserModel(
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
        profileImageDownloadURL:
            profileImageDownloadURL ?? this.profileImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        pendingCompanyRequestID:
            pendingCompanyRequestID ?? this.pendingCompanyRequestID,
        unregisteredPromoterIDs:
            unregisteredPromoterIDs ?? this.unregisteredPromoterIDs,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        tutorialStep: tutorialStep ?? this.tutorialStep,
        registeredPromoterIDs:
            registeredPromoterIDs ?? this.registeredPromoterIDs,
        landingPageIDs: landingPageIDs ?? this.landingPageIDs,
        recommendationIDs: recommendationIDs ?? this.recommendationIDs,
        favoriteRecommendationIDs:
            favoriteRecommendationIDs ?? this.favoriteRecommendationIDs,
        archivedRecommendationIDs:
            archivedRecommendationIDs ?? this.archivedRecommendationIDs,
        recommendationCountLast30Days:
            recommendationCountLast30Days ?? this.recommendationCountLast30Days,
        deletesAt: deletesAt ?? this.deletesAt,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        createdAt: createdAt ?? this.createdAt,
        recommendationCounterResetAt:
            recommendationCounterResetAt ?? this.recommendationCounterResetAt);
  }

  factory UserModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return UserModel.fromMap(doc).copyWith(id: id);
  }

  CustomUser toDomain() {
    return CustomUser(
        id: UniqueID.fromUniqueString(id),
        gender: gender == null
            ? Gender.none
            : Gender.values.firstWhere((element) => element.name == gender),
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        address: address,
        postCode: postCode,
        place: place,
        email: email,
        parentUserID: parentUserID,
        companyID: companyID,
        profileImageDownloadURL: profileImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL,
        pendingCompanyRequestID: pendingCompanyRequestID,
        defaultLandingPageID: defaultLandingPageID,
        tutorialStep: tutorialStep,
        unregisteredPromoterIDs: unregisteredPromoterIDs,
        registeredPromoterIDs: registeredPromoterIDs,
        landingPageIDs: landingPageIDs,
        recommendationIDs: recommendationIDs,
        favoriteRecommendationIDs: favoriteRecommendationIDs,
        archivedRecommendationIDs: archivedRecommendationIDs,
        recommendationCountLast30Days: recommendationCountLast30Days,
        deletesAt: deletesAt,
        lastUpdated: lastUpdated,
        createdAt: (createdAt as Timestamp).toDate(),
        recommendationCounterResetAt: recommendationCounterResetAt);
  }

  factory UserModel.fromDomain(CustomUser user) {
    return UserModel(
        id: user.id.value,
        gender: user.gender?.name,
        firstName: user.firstName,
        lastName: user.lastName,
        birthDate: user.birthDate,
        address: user.address,
        postCode: user.postCode,
        place: user.place,
        email: user.email,
        parentUserID: user.parentUserID,
        companyID: user.companyID,
        profileImageDownloadURL: user.profileImageDownloadURL,
        thumbnailDownloadURL: user.thumbnailDownloadURL,
        pendingCompanyRequestID: user.pendingCompanyRequestID,
        defaultLandingPageID: user.defaultLandingPageID,
        tutorialStep: user.tutorialStep,
        unregisteredPromoterIDs: user.unregisteredPromoterIDs,
        registeredPromoterIDs: user.registeredPromoterIDs,
        landingPageIDs: user.landingPageIDs,
        recommendationIDs: user.recommendationIDs,
        favoriteRecommendationIDs: user.favoriteRecommendationIDs,
        archivedRecommendationIDs: user.archivedRecommendationIDs,
        recommendationCountLast30Days: user.recommendationCountLast30Days,
        deletesAt: user.deletesAt,
        lastUpdated: user.lastUpdated,
        createdAt: FieldValue.serverTimestamp(),
        recommendationCounterResetAt: user.recommendationCounterResetAt);
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        gender,
        birthDate,
        address,
        postCode,
        place,
        email,
        parentUserID,
        companyID,
        profileImageDownloadURL,
        thumbnailDownloadURL,
        defaultLandingPageID,
        tutorialStep,
        unregisteredPromoterIDs,
        registeredPromoterIDs,
        landingPageIDs,
        recommendationIDs,
        favoriteRecommendationIDs,
        archivedRecommendationIDs,
        recommendationCountLast30Days,
        recommendationCounterResetAt
      ];
}
