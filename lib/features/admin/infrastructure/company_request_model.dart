// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/admin/domain/company_request.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/profile/infrastructure/company_model.dart';

class CompanyRequestModel extends Equatable {
  final String id;
  final Map<String, dynamic>? company;
  final String? userID;
  final dynamic createdAt;

  const CompanyRequestModel({
    required this.id,
    this.company,
    this.userID,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'company': company,
      'userID': userID,
      'createdAt': createdAt
    };
  }

  factory CompanyRequestModel.fromMap(Map<String, dynamic> map) {
    return CompanyRequestModel(
      id: "",
      company: map['company'] != null
          ? map['company'] as Map<String, dynamic>
          : null,
      userID: map['userID'] != null ? map['userID'] as String : null,
      createdAt: map['createdAt'] as dynamic,
    );
  }

  CompanyRequestModel copyWith({
    String? id,
    Map<String, dynamic>? company,
    String? userID,
    dynamic createdAt,
  }) {
    return CompanyRequestModel(
      id: id ?? this.id,
      company: company ?? this.company,
      userID: userID ?? this.userID,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CompanyRequestModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return CompanyRequestModel.fromMap(doc).copyWith(id: id);
  }

  CompanyRequest toDomain() {
    return CompanyRequest(
        id: UniqueID.fromUniqueString(id),
        company: CompanyModel.fromMap(company ?? {}).toDomain(),
        userID: UniqueID.fromUniqueString(userID ?? ""),
        createdAt: (createdAt as Timestamp).toDate());
  }

  factory CompanyRequestModel.fromDomain(CompanyRequest companyRequest) {
    if (companyRequest.company != null) {
      return CompanyRequestModel(
          id: companyRequest.id.value,
          company: CompanyModel.fromDomain(companyRequest.company!).toMap(),
          userID: companyRequest.userID?.value,
          createdAt: FieldValue.serverTimestamp());
    } else {
      return CompanyRequestModel(
          id: companyRequest.id.value,
          company: null,
          userID: companyRequest.userID?.value,
          createdAt: FieldValue.serverTimestamp());
    }
  }

  @override
  List<Object?> get props => [id, userID];
}
