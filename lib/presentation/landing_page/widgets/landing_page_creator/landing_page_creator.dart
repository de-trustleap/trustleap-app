import 'package:finanzbegleiter/application/images/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_image_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreator extends StatelessWidget {
  const LandingPageCreator({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => Modular.get<LandingPageImageBloc>()),
        BlocProvider(create: (context) => Modular.get<LandingPageCubit>())
      ],
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: themeData.colorScheme.background),
          child: ListView(children: [
            SizedBox(height: responsiveValue.isMobile ? 40 : 80),
            LandingPageCreatorImageSection(
                imageUploadSuccessful: () => CustomSnackBar.of(context)
                    .showCustomSnackBar(localization
                        .profile_page_snackbar_image_changed_message)),
            const SizedBox(height: 20),
            const CenteredConstrainedWrapper(child: LandingPageCreatorForm())
          ])),
    );
  }
}
