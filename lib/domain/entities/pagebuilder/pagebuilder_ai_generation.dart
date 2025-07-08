// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PagebuilderAiGeneration extends Equatable {
  final String? businessType;
  final String? customDescription;

  const PagebuilderAiGeneration({
    this.businessType,
    this.customDescription,
  });

  PagebuilderAiGeneration copyWith({
    String? businessType,
    String? customDescription,
  }) {
    return PagebuilderAiGeneration(
      businessType: businessType ?? this.businessType,
      customDescription: customDescription ?? this.customDescription,
    );
  }

  bool get hasContent => 
      (businessType?.isNotEmpty ?? false) || 
      (customDescription?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [businessType, customDescription];
}
