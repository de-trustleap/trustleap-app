import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverview extends StatelessWidget {
  const LandingPageOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final themeData = Theme.of(context);

      return Column(
        children: [
          Text("Landing Pages Übersicht", style: themeData.textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold)),
        ],
      );
    }));
  }
}