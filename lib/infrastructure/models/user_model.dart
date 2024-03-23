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
  final String? profileImageDownloadURL;
  final String? thumbnailDownloadURL;
  final List<String>? promoters;
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
      this.profileImageDownloadURL,
      this.thumbnailDownloadURL,
      this.promoters,
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
      'profileImageDownloadURL': profileImageDownloadURL,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'promoters': promoters,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: "",
      gender: map['gender'] != null ? map['gender'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      postCode: map['postCode'] != null ? map['postCode'] as String : null,
      place: map['place'] != null ? map['place'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      profileImageDownloadURL: map['profileImageDownloadURL'] != null
          ? map['profileImageDownloadURL'] as String
          : null,
      thumbnailDownloadURL: map['thumbnailDownloadURL'] != null
          ? map['thumbnailDownloadURL'] as String
          : null,
      promoters:
          map['promoters'] != null ? List<String>.from(map['promoters']) : null,
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
    String? profileImageDownloadURL,
    String? thumbnailDownloadURL,
    List<String>? promoters,
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
      profileImageDownloadURL:
          profileImageDownloadURL ?? this.profileImageDownloadURL,
      thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
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
        gender: Gender.values.firstWhere((element) =>
            element.name ==
            gender), // TODO: Im Test crasht es hier wenn gender = null ist.
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        address: address,
        postCode: postCode,
        place: place,
        email: email,
        profileImageDownloadURL: profileImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL,
        promoters: promoters);
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
        profileImageDownloadURL: user.profileImageDownloadURL,
        thumbnailDownloadURL: user.thumbnailDownloadURL,
        promoters: user.promoters,
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
        profileImageDownloadURL,
        thumbnailDownloadURL,
        promoters
      ];
}
