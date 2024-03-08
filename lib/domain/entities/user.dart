// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/id.dart';

class CustomUser {
  UniqueID id;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? address;
  final String? postCode;
  final String? place;
  final String? profileImageURL;
  final List<String>? promoters;

  CustomUser(
      {required this.id,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.address,
      this.postCode,
      this.place,
      this.profileImageURL,
      this.promoters});

  CustomUser copyWith(
      {UniqueID? id,
      String? firstName,
      String? lastName,
      String? birthDate,
      String? address,
      String? postCode,
      String? place,
      String? profileImageURL,
      List<String>? promoters}) {
    return CustomUser(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthDate: birthDate ?? this.birthDate,
        address: address ?? this.address,
        postCode: postCode ?? this.postCode,
        place: place ?? this.place,
        profileImageURL: profileImageURL ?? this.profileImageURL,
        promoters: promoters ?? this.promoters);
  }
}
