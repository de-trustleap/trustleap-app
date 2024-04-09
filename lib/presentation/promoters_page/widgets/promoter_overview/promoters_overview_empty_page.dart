// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class PromotersOverviewEmptyPage extends StatelessWidget {
  final Function registerPromoterTapped;

  const PromotersOverviewEmptyPage({
    Key? key,
    required this.registerPromoterTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(color: themeData.colorScheme.background),
        child: CenteredConstrainedWrapper(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add,
                size: responsiveValue.isMobile ? 40 : 60,
                color: themeData.colorScheme.secondary),
            const SizedBox(height: 16),
            Text(localization.promoter_overview_empty_page_title,
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: responsiveValue.isMobile ? 20 : 24)),
            const SizedBox(height: 16),
            Text(localization.promoter_overview_empty_page_subtitle,
                style: themeData.textTheme.headlineLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                    title:
                        localization.promoter_overview_empty_page_button_title,
                    width: responsiveValue.isMobile
                        ? responsiveValue.screenWidth - 20
                        : 300,
                    onTap: () {
                      registerPromoterTapped();
                    }),
              ],
            )
          ],
        )));
  }
}
