import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';

class CompanyRequestsOverview extends StatelessWidget {
  const CompanyRequestsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ListView(shrinkWrap: true, children: [
      CardContainer(child: LayoutBuilder(builder: ((context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Text("Anfragen für Unternehmensregistrierung",
            style: themeData.textTheme.headlineLarge!
                .copyWith(fontWeight: FontWeight.bold));
      })))
    ]);
  }
}
