// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_overview/landing_page_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageView extends StatefulWidget {
  final String? createdNewPage;
  final String? editedPage;

  const LandingPageView({super.key, this.createdNewPage, this.editedPage});

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  bool initialSnackbarAlreadyShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialSnackbarAlreadyShown) {
      if (widget.createdNewPage == "true") {
        final localization = AppLocalizations.of(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomSnackBar.of(context)
              .showCustomSnackBar(localization.landingpage_snackbar_success);
        });
      } else if (widget.editedPage == "true") {
        final localization = AppLocalizations.of(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomSnackBar.of(context).showCustomSnackBar(
              localization.landingpage_snackbar_success_changed);
        });
      }
      initialSnackbarAlreadyShown = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => Modular.get<LandingPageObserverCubit>()
              ..observeAllLandingPages()),
        BlocProvider(create: (context) => Modular.get<LandingPageCubit>())
      ],
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: themeData.colorScheme.surface),
          child: ListView(children: [
            SizedBox(height: responsiveValue.isMobile ? 40 : 80),
            const CenteredConstrainedWrapper(
              child: LandingPageOverview(),
            )
          ])),
    );
  }
}
