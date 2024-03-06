import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile_bloc/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/contact_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/promoters_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileGeneralView extends StatelessWidget {
  const ProfileGeneralView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
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
                      ContactSection(
                          user: state.user,
                          changesSaved: () => {
                                CustomSnackBar.of(context).showCustomSnackBar(
                                    "Die Änderung deiner Kontaktinformationen war erfolgreich.")
                              }),
                      const SizedBox(height: 60),
                      EmailSection(
                          user: state.user,
                          sendEmailVerificationCallback: () => {
                                CustomSnackBar.of(context).showCustomSnackBar(
                                    "Es wurde ein Link zur E-Mail Verifikation an dich versendet.")
                              }),
                      const SizedBox(height: 60),
                      PromotersSection(user: state.user),
                      const SizedBox(height: 60),
                      SecondaryButton(
                          title: "Abmelden",
                          width: 200,
                          onTap: () => {
                                BlocProvider.of<ProfileCubit>(context)
                                    .signOutUser()
                              }),
                      const SizedBox(height: 100)
                    ])),
              ]));
        } else if (state is ProfileObserverFailure) {
          return CenteredConstrainedWrapper(
              child: ErrorView(
                  title: "Ein Fehler beim Abruf der Daten ist aufgetreten.",
                  message:
                      DatabaseFailureMapper.mapFailureMessage(state.failure),
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
