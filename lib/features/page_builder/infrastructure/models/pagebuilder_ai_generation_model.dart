// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_ai_generation.dart';

class PagebuilderAiGenerationModel extends Equatable {
  final String? businessType;
  final String? customDescription;

  const PagebuilderAiGenerationModel({
    this.businessType,
    this.customDescription,
  });

  PagebuilderAiGenerationModel copyWith({
    String? businessType,
    String? customDescription,
  }) {
    return PagebuilderAiGenerationModel(
      businessType: businessType ?? this.businessType,
      customDescription: customDescription ?? this.customDescription,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (businessType != null) map['businessType'] = businessType;
    if (customDescription != null) map['customDescription'] = customDescription;
    return map;
  }

  factory PagebuilderAiGenerationModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderAiGenerationModel(
        businessType:
            map['businessType'] != null ? map['businessType'] as String : null,
        customDescription: map['customDescription'] != null
            ? map['customDescription'] as String
            : null);
  }

  PagebuilderAiGeneration toDomain() {
    return PagebuilderAiGeneration(
        businessType: businessType, customDescription: customDescription);
  }

  factory PagebuilderAiGenerationModel.fromDomain(
      PagebuilderAiGeneration properties) {
    return PagebuilderAiGenerationModel(
        businessType: properties.businessType,
        customDescription: properties.customDescription);
  }

  @override
  List<Object?> get props => [businessType, customDescription];
}
