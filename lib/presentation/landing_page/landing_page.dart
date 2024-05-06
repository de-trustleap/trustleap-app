import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/landing_page/landing_page_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageView extends StatelessWidget {
  const LandingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return BlocProvider(
      create: (context) => Modular.get<LandingPageCubit>()..observeAllLandingPages(),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: themeData.colorScheme.background),
          child: ListView(children: [
            SizedBox(height: responsiveValue.isMobile ? 40 : 80),
            const CenteredConstrainedWrapper(
              child: LandingPageOverview(),
            )
          ])),
    );
  }
}
