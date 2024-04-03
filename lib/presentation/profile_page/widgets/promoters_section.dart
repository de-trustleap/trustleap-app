// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
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
    final localization = AppLocalizations.of(context);

    return CardContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(localization.profile_page_promoters_section_title,
          style: themeData.textTheme.headlineLarge!
              .copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(localization.profile_page_promoters_section_recommender_count,
            style: themeData.textTheme.bodyMedium),
        const SizedBox(width: 16),
        Text(user.registeredPromoterIDs?.length.toString() ?? "0",
            style: themeData.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        const Spacer()
      ])
    ]));
  }
}
