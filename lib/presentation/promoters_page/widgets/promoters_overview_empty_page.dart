// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class PromotersOverviewEmptyPage extends StatelessWidget {
  final Function registerPromoterTapped;

  const PromotersOverviewEmptyPage({
    Key? key,
    required this.registerPromoterTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(color: themeData.colorScheme.background),
        child: CenteredConstrainedWrapper(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add,
                size: 60, color: themeData.colorScheme.secondary),
            const SizedBox(height: 16),
            Text("Keine Promoter gefunden",
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
                "Sie scheinen noch keine Promoter registriert zu haben. Registrieren Sie jetzt ihre Promoter um die ersten Neukunden zu gewinnen.",
                style:
                    themeData.textTheme.headlineLarge!.copyWith(fontSize: 20),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                    title: "Promoter registrieren",
                    width: 300,
                    onTap: () {
                      registerPromoterTapped();
                    }),
              ],
            )
          ],
        )));
  }
}
