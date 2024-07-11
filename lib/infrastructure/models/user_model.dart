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
  final String? role;
  final String? profileImageDownloadURL;
  final String? thumbnailDownloadURL;
  final List<String>? unregisteredPromoterIDs;
  final List<String>? registeredPromoterIDs;
  final List<String>? landingPageIDs;
  final DateTime? deletesAt;
  final DateTime? lastUpdated;
  final dynamic createdAt;

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
      this.role,
      this.profileImageDownloadURL,
      this.thumbnailDownloadURL,
      this.unregisteredPromoterIDs,
      this.registeredPromoterIDs,
      this.landingPageIDs,
      this.deletesAt,
      this.lastUpdated,
      this.createdAt});

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
      'role': role,
      'profileImageDownloadURL': profileImageDownloadURL,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'unregisteredPromoterIDs': unregisteredPromoterIDs,
      'registeredPromoterIDs': registeredPromoterIDs,
      'landingPageIDs': landingPageIDs,
      'deletesAt': deletesAt,
      'lastUpdated': lastUpdated,
      'createdAt': createdAt,
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
      role: map['role'] != null ? map['role'] as String : "none",
      profileImageDownloadURL: map['profileImageDownloadURL'] != null
          ? map['profileImageDownloadURL'] as String
          : null,
      thumbnailDownloadURL: map['thumbnailDownloadURL'] != null
          ? map['thumbnailDownloadURL'] as String
          : null,
      unregisteredPromoterIDs: map['unregisteredPromoterIDs'] != null
          ? List<String>.from(map['unregisteredPromoterIDs'])
          : null,
      registeredPromoterIDs: map['registeredPromoterIDs'] != null
          ? List<String>.from(map['registeredPromoterIDs'])
          : null,
      landingPageIDs: map['landingPageIDs'] != null
          ? List<String>.from(map['landingPageIDs'])
          : null,
      deletesAt: map['deletesAt'] != null
          ? (map['deletesAt'] as Timestamp).toDate()
          : null,
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : null,
      createdAt: map['createdAt'] as dynamic,
    );
  }

  UserModel copyWith({
    String? id,
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
    String? role,
    String? profileImageDownloadURL,
    String? thumbnailDownloadURL,
    List<String>? unregisteredPromoterIDs,
    List<String>? registeredPromoterIDs,
    List<String>? landingPageIDs,
    DateTime? deletesAt,
    DateTime? lastUpdated,
    dynamic createdAt,
  }) {
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
      role: role ?? this.role,
      profileImageDownloadURL:
          profileImageDownloadURL ?? this.profileImageDownloadURL,
      thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
      unregisteredPromoterIDs:
          unregisteredPromoterIDs ?? this.unregisteredPromoterIDs,
      registeredPromoterIDs:
          registeredPromoterIDs ?? this.registeredPromoterIDs,
      landingPageIDs: landingPageIDs ?? this.landingPageIDs,
      deletesAt: deletesAt ?? this.deletesAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
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
        role: role == null
            ? Role.none
            : Role.values.firstWhere((element) => element.name == role),
        profileImageDownloadURL: profileImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL,
        unregisteredPromoterIDs: unregisteredPromoterIDs,
        registeredPromoterIDs: registeredPromoterIDs,
        landingPageIDs: landingPageIDs,
        deletesAt: deletesAt,
        lastUpdated: lastUpdated,
        createdAt: (createdAt as Timestamp).toDate());
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
        role: user.role?.name,
        profileImageDownloadURL: user.profileImageDownloadURL,
        thumbnailDownloadURL: user.thumbnailDownloadURL,
        unregisteredPromoterIDs: user.unregisteredPromoterIDs,
        registeredPromoterIDs: user.registeredPromoterIDs,
        landingPageIDs: user.landingPageIDs,
        deletesAt: user.deletesAt,
        lastUpdated: user.lastUpdated,
        createdAt: FieldValue.serverTimestamp());
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
        role,
        profileImageDownloadURL,
        thumbnailDownloadURL,
        unregisteredPromoterIDs,
        registeredPromoterIDs,
        landingPageIDs
      ];
}
