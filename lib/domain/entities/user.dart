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
  final String? profileImageDownloadURL;
  final String? thumbnailDownloadURL;
  final List<String>? unregisteredPromoterIDs;
  final List<String>? registeredPromoterIDs;
  final DateTime? deletesAt;
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
      this.profileImageDownloadURL,
      this.thumbnailDownloadURL,
      this.unregisteredPromoterIDs,
      this.registeredPromoterIDs,
      this.deletesAt,
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
      String? profileImageDownloadURL,
      String? thumbnailDownloadURL,
      List<String>? unregisteredPromoterIDs,
      List<String>? registeredPromoterIDs,
      DateTime? deletesAt,
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
        profileImageDownloadURL:
            profileImageDownloadURL ?? this.profileImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        unregisteredPromoterIDs:
            unregisteredPromoterIDs ?? this.unregisteredPromoterIDs,
        registeredPromoterIDs:
            registeredPromoterIDs ?? this.registeredPromoterIDs,
        deletesAt: deletesAt ?? this.deletesAt,
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
        profileImageDownloadURL,
        thumbnailDownloadURL,
        unregisteredPromoterIDs,
        registeredPromoterIDs
      ];
}
