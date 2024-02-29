import 'package:finanzbegleiter/application/authentication/user/user_bloc.dart';
import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile_bloc/profile_bloc.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/injection.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/page_template.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/error_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/contact_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final profileObserverBloc = sl<ProfileObserverBloc>()
      ..add(ProfileObserveAllEvent());
    return PageTemplate(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => profileObserverBloc),
          BlocProvider(
              create: (context) => sl<ProfileBloc>()
                ..add(VerifyEmailEvent())
                ..add(GetCurrentUserEvent())),
          BlocProvider(create: (context) => sl<UserBloc>())
        ],
        child: BlocBuilder<ProfileObserverBloc, ProfileObserverState>(
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
                          ContactSection(user: state.user),
                          const SizedBox(height: 60),
                          EmailSection(user: state.user),
                          const SizedBox(height: 100)
                        ])),
                  ]));
            } else if (state is ProfileObserverFailure) {
              return CenteredConstrainedWrapper(
                  child: ErrorView(
                      title: "Ein Fehler beim Abruf der Daten ist aufgetreten.",
                      message: DatabaseFailureMapper.mapFailureMessage(
                          state.failure),
                      callback: () =>
                          {profileObserverBloc.add(ProfileObserveAllEvent())}));
            } else {
              return CenteredConstrainedWrapper(
                  child: CircularProgressIndicator(
                      color: themeData.colorScheme.secondary));
            }
          },
        ),
      ),
    );
  }
}
