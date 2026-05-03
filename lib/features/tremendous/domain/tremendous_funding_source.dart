import 'package:equatable/equatable.dart';

class TremendousFundingSource extends Equatable {
  final String id;
  final String method;
  final int? availableCents;
  final String? currencyCode;

  const TremendousFundingSource({
    required this.id,
    required this.method,
    this.availableCents,
    this.currencyCode,
  });

  factory TremendousFundingSource.fromMap(Map<String, dynamic> map) {
    final meta = map['meta'] as Map<String, dynamic>?;
    return TremendousFundingSource(
      id: map['id'] as String,
      method: map['method'] as String,
      availableCents: meta?['available_cents'] as int?,
      currencyCode: meta?['available_currency_code'] as String?,
    );
  }

  String get displayName => method;

  @override
  List<Object?> get props => [id, method, availableCents, currencyCode];
}
