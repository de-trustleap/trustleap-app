// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';

class PromotersSection extends StatelessWidget {
  final CustomUser user;

  const PromotersSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return CardContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Empfehlungsgeber",
          style: themeData.textTheme.headlineLarge!
              .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text("Anzahl der Empfehlungsgeber:",
            style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
        const SizedBox(width: 16),
        Text(user.promoters?.length.toString() ?? "0",
            style: themeData.textTheme.headlineLarge!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        const Spacer()
      ])
    ]));
  }
}
