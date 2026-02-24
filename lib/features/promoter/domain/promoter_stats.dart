import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/conversion_rate_formatter.dart';

class PromoterStats extends Equatable {
  final int shares;
  final int conversions;

  const PromoterStats({
    required this.shares,
    required this.conversions,
  });

  double get performance => shares > 0 ? conversions / shares : 0.0;

  String get formattedConversionRate =>
      ConversionRateFormatter.format(total: shares, successful: conversions);

  @override
  List<Object?> get props => [shares, conversions];
}
