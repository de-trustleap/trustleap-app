import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreator extends StatelessWidget {
  const LandingPageCreator({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.background),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          const CenteredConstrainedWrapper(child: LandingPageCreatorForm())
          // CenteredConstrainedWrapper(
          //     child: BlocProvider(
          //         create: (context) =>
          //             Modular.get<RecommendationsCubit>()..getUser(),
          //         child: const RecommendationsForm()))
        ]));
  }
}