import 'package:equatable/equatable.dart';

class PromoterStats extends Equatable {
  final int shares;
  final int conversions;

  const PromoterStats({
    required this.shares,
    required this.conversions,
  });

  double get performance => shares > 0 ? conversions / shares : 0.0;

  @override
  List<Object?> get props => [shares, conversions];
}
