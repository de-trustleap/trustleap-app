import 'package:equatable/equatable.dart';

class TremendousOrderRequest extends Equatable {
  final String productID;
  final String fundingSourceID;
  final double amount;
  final String currency;

  const TremendousOrderRequest({
    required this.productID,
    required this.fundingSourceID,
    required this.amount,
    required this.currency,
  });

  @override
  List<Object?> get props => [productID, fundingSourceID, amount, currency];
}
