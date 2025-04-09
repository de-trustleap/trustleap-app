import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class LeadItem extends Equatable {
  final String id;
  final String name;
  final String reason;
  final String promotionTemplate;
  final String promoterName;
  final String serviceProviderName;

  static final _uuid = UniqueID();

  LeadItem(
      {String? id,
      required this.name,
      required this.reason,
      required this.promotionTemplate,
      required this.promoterName,
      required this.serviceProviderName})
      : id = id ?? _uuid.toString();

  @override
  List<Object?> get props => [id, name, reason];
}
