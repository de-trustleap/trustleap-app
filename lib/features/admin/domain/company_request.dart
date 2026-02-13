// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/core/id.dart';

class CompanyRequest extends Equatable {
  final UniqueID id;
  final Company? company;
  final UniqueID? userID;
  final DateTime? createdAt;

  const CompanyRequest({
    required this.id,
    this.company,
    this.userID,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id];

  CompanyRequest copyWith({
    UniqueID? id,
    Company? company,
    UniqueID? userID,
    DateTime? createdAt,
  }) {
    return CompanyRequest(
      id: id ?? this.id,
      company: company ?? this.company,
      userID: userID ?? this.userID,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
