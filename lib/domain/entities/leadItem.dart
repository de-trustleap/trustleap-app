import 'package:equatable/equatable.dart';

class LeadItem extends Equatable {
  final String name;
  final String reason;
  final String promotionTemplate;

  const LeadItem({
    required this.name
  , required this.reason
  , required this.promotionTemplate
  });

  @override
  List<Object?> get props => [name, reason];
}