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
  final String? parentUserID;
  final String? code;
  final dynamic createdAt;

  const UnregisteredPromoterModel(
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

  factory UnregisteredPromoterModel.fromMap(Map<String, dynamic> map) {
    return UnregisteredPromoterModel(
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

  UnregisteredPromoterModel copyWith({
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
    return UnregisteredPromoterModel(
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

  factory UnregisteredPromoterModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return UnregisteredPromoterModel.fromMap(doc.data()!).copyWith(id: doc.id);
  }

  UnregisteredPromoter toDomain() {
    return UnregisteredPromoter(
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

  factory UnregisteredPromoterModel.fromDomain(UnregisteredPromoter promoter) {
    return UnregisteredPromoterModel(
        id: promoter.id?.value ?? "",
        gender: promoter.gender?.name,
        firstName: promoter.firstName,
        lastName: promoter.lastName,
        birthDate: promoter.birthDate,
        email: promoter.email,
        parentUserID: promoter.parentUserID?.value ?? "",
        code: promoter.code?.value,
        createdAt: FieldValue.serverTimestamp());
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, gender, email, birthDate, parentUserID, code];
}
