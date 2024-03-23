// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/registered_recommendor.dart';

class UnregisteredRecommendorModel extends Equatable {
  final String id;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? email;
  final String? parentUserID;
  final String? code;
  final dynamic createdAt;

  const UnregisteredRecommendorModel(
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

  factory UnregisteredRecommendorModel.fromMap(Map<String, dynamic> map) {
    return UnregisteredRecommendorModel(
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

  UnregisteredRecommendorModel copyWith({
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
    return UnregisteredRecommendorModel(
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

  factory UnregisteredRecommendorModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return UnregisteredRecommendorModel.fromMap(doc.data()!)
        .copyWith(id: doc.id);
  }

  UnregisteredRecommendor toDomain() {
    return UnregisteredRecommendor(
        id: UniqueID.fromUniqueString(id),
        gender: Gender.values.firstWhere((element) =>
            element.name ==
            gender), // TODO: Im Test crasht es hier wenn gender = null ist.
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        email: email,
        parentUserID: UniqueID.fromUniqueString(parentUserID ?? ""),
        code: UniqueID.fromUniqueString(code ?? ""));
  }

  factory UnregisteredRecommendorModel.fromDomain(
      UnregisteredRecommendor recommendor) {
    return UnregisteredRecommendorModel(
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

  @override
  List<Object?> get props =>
      [id, firstName, lastName, gender, email, birthDate, parentUserID, code];
}
