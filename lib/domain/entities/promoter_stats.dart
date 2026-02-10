import 'package:equatable/equatable.dart';

class PromoterStats extends Equatable {
  final int shares;
  final int conversions;

  const PromoterStats({
    required this.shares,
    required this.conversions,
  });

  double get performance => shares > 0 ? conversions / shares : 0.0;

  String get formattedConversionRate {
    final percentage = performance * 100;
    if (percentage == percentage.roundToDouble()) {
      return '${percentage.toStringAsFixed(0)}%';
    }
    return '${percentage.toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [shares, conversions];
}
