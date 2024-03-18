// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class RegisteredRecommendor {
  final UniqueID? id;
  final Gender? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? email;
  final UniqueID? code;

  RegisteredRecommendor({
    required this.id,
    this.gender,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.email,
    this.code
  });

  RegisteredRecommendor copyWith({
    UniqueID? id,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? email,
    UniqueID? code
  }) {
    return RegisteredRecommendor(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      code: code ?? this.code
    );
  }
}
