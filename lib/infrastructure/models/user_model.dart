// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? address;
  final String? postCode;
  final String? place;
  final dynamic createdAt;

  UserModel(
      {required this.id,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.address,
      this.postCode,
      this.place,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'address': address,
      'postCode': postCode,
      'place': place,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: "",
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      postCode: map['postCode'] != null ? map['postCode'] as String : null,
      place: map['place'] != null ? map['place'] as String : null,
      createdAt: map['createdAt'] as dynamic,
    );
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? address,
    String? postCode,
    String? place,
    dynamic createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      postCode: postCode ?? this.postCode,
      place: place ?? this.place,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel.fromMap(doc.data()!).copyWith(id: doc.id);
  }

  CustomUser toDomain() {
    return CustomUser(
        id: UniqueID.fromUniqueString(id),
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        address: address,
        postCode: postCode,
        place: place);
  }

  factory UserModel.fromDomain(CustomUser user) {
    return UserModel(
        id: user.id.value,
        firstName: user.firstName,
        lastName: user.lastName,
        birthDate: user.birthDate,
        address: user.address,
        postCode: user.postCode,
        place: user.place,
        createdAt: FieldValue.serverTimestamp());
  }
}
