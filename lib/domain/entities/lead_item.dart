import 'package:equatable/equatable.dart';

class Recommendation extends Equatable {
  final String id;
  final String name;
  final String reason;
  final String landingPageID;
  final String promotionTemplate;
  final String promoterName;
  final String serviceProviderName;

  const Recommendation(
      {required this.id,
      required this.name,
      required this.reason,
      required this.landingPageID,
      required this.promotionTemplate,
      required this.promoterName,
      required this.serviceProviderName});

  @override
  List<Object?> get props => [
        id,
        name,
        reason,
        landingPageID,
        promotionTemplate,
        promoterName,
        serviceProviderName
      ];
}
