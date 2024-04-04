import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/contact_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/profile_image_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/promoters_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class ProfileGeneralView extends StatefulWidget {
  const ProfileGeneralView({super.key});

  @override
  State<ProfileGeneralView> createState() => _ProfileGeneralViewState();
}

class _ProfileGeneralViewState extends State<ProfileGeneralView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final profileObserverBloc = Modular.get<ProfileObserverBloc>();

    return BlocBuilder<ProfileObserverBloc, ProfileObserverState>(
      builder: (context, state) {
        if (state is ProfileObserverLoading) {
          return CenteredConstrainedWrapper(
              child: CircularProgressIndicator(
                  color: themeData.colorScheme.secondary));
        } else if (state is ProfileObserverSuccess) {
          return Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(color: themeData.colorScheme.background),
              child: ListView(children: [
                const SizedBox(height: 80),
                CenteredConstrainedWrapper(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      ProfileImageSection(
                          user: state.user,
                          imageUploadSuccessful: () => {
                                CustomSnackBar.of(context).showCustomSnackBar(
                                    localization
                                        .profile_page_snackbar_image_changed_message)
                              }),
                      const SizedBox(height: 20),
                      ContactSection(
                          user: state.user,
                          changesSaved: () => {
                                CustomSnackBar.of(context).showCustomSnackBar(
                                    localization
                                        .profile_page_snackbar_contact_information_changes)
                              }),
                      SizedBox(height: responsiveValue.isMobile ? 20 : 60),
                      EmailSection(
                          user: state.user,
                          sendEmailVerificationCallback: () => {
                                CustomSnackBar.of(context).showCustomSnackBar(
                                    localization
                                        .profile_page_snackbar_email_verification)
                              }),
                      SizedBox(height: responsiveValue.isMobile ? 20 : 60),
                      PromotersSection(user: state.user),
                      SizedBox(height: responsiveValue.isMobile ? 20 : 60),
                      SecondaryButton(
                          title: localization.profile_page_logout_button_title,
                          width: responsiveValue.isMobile ? responsiveValue.screenWidth - 80 : 200,
                          onTap: () => {
                                BlocProvider.of<ProfileCubit>(context)
                                    .signOutUser()
                              }),
                      SizedBox(height: responsiveValue.isMobile ? 50 : 100)
                    ])),
              ]));
        } else if (state is ProfileObserverFailure) {
          return CenteredConstrainedWrapper(
              child: ErrorView(
                  title: localization.profile_page_request_failure_message,
                  message: DatabaseFailureMapper.mapFailureMessage(
                      state.failure, localization),
                  callback: () =>
                      {profileObserverBloc.add(ProfileObserveAllEvent())}));
        } else {
          return CenteredConstrainedWrapper(
              child: CircularProgressIndicator(
                  color: themeData.colorScheme.secondary));
        }
      },
    );
  }
}
