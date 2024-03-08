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
  final String? profileImageURL;
  final List<String>? promoters;
  final dynamic createdAt;

  UserModel(
      {required this.id,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.address,
      this.postCode,
      this.place,
      this.profileImageURL,
      this.promoters,
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
      'profileImageURL': profileImageURL,
      'promoters': promoters,
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
      profileImageURL: map['profileImageURL'] != null
          ? map['profileImageURL'] as String
          : null,
      promoters:
          map['promoters'] != null ? List<String>.from(map['promoters']) : null,
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
    String? profileImageURL,
    List<String>? promoters,
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
      profileImageURL: profileImageURL ?? this.profileImageURL,
      promoters: promoters ?? this.promoters,
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
        place: place,
        profileImageURL: profileImageURL,
        promoters: promoters);
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
        profileImageURL: user.profileImageURL,
        promoters: user.promoters,
        createdAt: FieldValue.serverTimestamp());
  }
}
