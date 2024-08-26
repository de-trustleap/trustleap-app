// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';

class UnregisteredPromoterModel extends Equatable {
  final String id;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? email;
  final List<String>? landingPageIDs;
  final String? defaultLandingPageID;
  final String? parentUserID;
  final String? companyID;
  final String? code;
  final DateTime expiresAt;
  final dynamic createdAt;

  const UnregisteredPromoterModel(
      {required this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.email,
      this.landingPageIDs,
      this.defaultLandingPageID,
      this.parentUserID,
      this.companyID,
      this.code,
      required this.expiresAt,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gender': gender,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'email': email,
      'landingPageIDs': landingPageIDs,
      'defaultLandingPageID': defaultLandingPageID,
      'parentUserID': parentUserID,
      'companyID': companyID,
      'code': code,
      'expiresAt': expiresAt,
      'createdAt': createdAt
    };
  }

  factory UnregisteredPromoterModel.fromMap(Map<String, dynamic> map) {
    return UnregisteredPromoterModel(
        id: "",
        gender: map['gender'] != null ? map['gender'] as String : "none",
        firstName: map['firstName'] != null ? map['firstName'] as String : null,
        lastName: map['lastName'] != null ? map['lastName'] as String : null,
        birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
        email: map['email'] != null ? map['email'] as String : null,
        landingPageIDs: map['landingPageIDs'] != null
            ? List<String>.from(map['landingPageIDs'])
            : null,
        defaultLandingPageID: map['defaultLandingPageID'] != null
            ? map['defaultLandingPageID'] as String
            : null,
        parentUserID:
            map['parentUserID'] != null ? map['parentUserID'] as String : null,
        companyID: map['companyID'] != null ? map['companyID'] as String : null,
        code: map['code'] != null ? map['code'] as String : null,
        expiresAt: (map['expiresAt'] as Timestamp).toDate(),
        createdAt: map['createdAt'] as dynamic);
  }

  UnregisteredPromoterModel copyWith({
    String? id,
    String? gender,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? email,
    List<String>? landingPageIDs,
    String? defaultLandingPageID,
    String? parentUserID,
    String? companyID,
    String? code,
    DateTime? expiresAt,
    dynamic createdAt,
  }) {
    return UnregisteredPromoterModel(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      landingPageIDs: landingPageIDs ?? this.landingPageIDs,
      defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
      parentUserID: parentUserID ?? this.parentUserID,
      companyID: companyID ?? this.companyID,
      code: code ?? this.code,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UnregisteredPromoterModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return UnregisteredPromoterModel.fromMap(doc).copyWith(id: id);
  }

  UnregisteredPromoter toDomain() {
    return UnregisteredPromoter(
        id: UniqueID.fromUniqueString(id),
        gender: gender == null
            ? Gender.none
            : Gender.values.firstWhere((element) => element.name == gender),
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        email: email,
        landingPageIDs: landingPageIDs,
        defaultLandingPageID: defaultLandingPageID != null ? UniqueID.fromUniqueString(defaultLandingPageID ?? "") : null,
        parentUserID: parentUserID != null ? UniqueID.fromUniqueString(parentUserID ?? "") : null,
        companyID: companyID != null ? UniqueID.fromUniqueString(companyID ?? "") : null,
        code: code != null ? UniqueID.fromUniqueString(code ?? "") : null,
        expiresAt: expiresAt);
  }

  factory UnregisteredPromoterModel.fromDomain(UnregisteredPromoter promoter) {
    return UnregisteredPromoterModel(
        id: promoter.id.value,
        gender: promoter.gender?.name,
        firstName: promoter.firstName,
        lastName: promoter.lastName,
        birthDate: promoter.birthDate,
        email: promoter.email,
        landingPageIDs: promoter.landingPageIDs,
        defaultLandingPageID: promoter.defaultLandingPageID?.value ?? "",
        parentUserID: promoter.parentUserID?.value ?? "",
        companyID: promoter.companyID?.value ?? "",
        code: promoter.code?.value,
        expiresAt: promoter.expiresAt,
        createdAt: FieldValue.serverTimestamp());
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        gender,
        email,
        birthDate,
        parentUserID,
        companyID,
        code,
        landingPageIDs,
        defaultLandingPageID
      ];
}
