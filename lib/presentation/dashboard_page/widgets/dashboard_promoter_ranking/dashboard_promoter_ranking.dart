import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';

class DashboardPromoterRanking extends StatefulWidget {
  final CustomUser user;
  const DashboardPromoterRanking({super.key, required this.user});

  @override
  State<DashboardPromoterRanking> createState() =>
      _DashboardPromoterRankingState();
}

class _DashboardPromoterRankingState extends State<DashboardPromoterRanking> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CardContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Promoter Rangliste",
          style: themeData.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
      ],
    ));
  }
}
