// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/registered_recommendor.dart';

class RegisteredRecommendorModel {
  final String id;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? email;
  final String? parentUserID;
  final String? code;
  final dynamic createdAt;

  RegisteredRecommendorModel(
      {required this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.email,
      this.parentUserID,
      this.code,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gender': gender,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'email': email,
      'parentUserID': parentUserID,
      'code': code,
      'createdAt': createdAt
    };
  }

  factory RegisteredRecommendorModel.fromMap(Map<String, dynamic> map) {
    return RegisteredRecommendorModel(
        id: "",
        gender: map['gender'] != null ? map['gender'] as String : null,
        firstName: map['firstName'] != null ? map['firstName'] as String : null,
        lastName: map['lastName'] != null ? map['lastName'] as String : null,
        birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
        email: map['email'] != null ? map['email'] as String : null,
        parentUserID:
            map['parentUserID'] != null ? map['parentUserID'] as String : null,
        code: map['code'] != null ? map['code'] as String : null,
        createdAt: map['createdAt'] as dynamic);
  }

  RegisteredRecommendorModel copyWith({
    String? id,
    String? gender,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? email,
    String? parentUserID,
    String? code,
    dynamic createdAt,
  }) {
    return RegisteredRecommendorModel(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      parentUserID: parentUserID ?? this.parentUserID,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RegisteredRecommendorModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return RegisteredRecommendorModel.fromMap(doc.data()!).copyWith(id: doc.id);
  }

  RegisteredRecommendor toDomain() {
    return RegisteredRecommendor(
        id: UniqueID.fromUniqueString(id),
        gender: Gender.values.firstWhere((element) => element.name == gender),
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        email: email,
        parentUserID: UniqueID.fromUniqueString(parentUserID ?? ""),
        code: UniqueID.fromUniqueString(code ?? ""));
  }

  factory RegisteredRecommendorModel.fromDomain(
      RegisteredRecommendor recommendor) {
    return RegisteredRecommendorModel(
        id: recommendor.id?.value ?? "",
        gender: recommendor.gender?.name,
        firstName: recommendor.firstName,
        lastName: recommendor.lastName,
        birthDate: recommendor.birthDate,
        email: recommendor.email,
        parentUserID: recommendor.parentUserID?.value ?? "",
        code: recommendor.code?.value,
        createdAt: FieldValue.serverTimestamp());
  }
}
