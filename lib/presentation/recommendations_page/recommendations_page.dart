import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendations_form.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.surface),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          const CenteredConstrainedWrapper(child: RecommendationsForm())
        ]));
  }
}
