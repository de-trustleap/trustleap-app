import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/password_update/profile_password_update_form.dart';
import 'package:flutter/material.dart';

class ProfilePasswordUpdateView extends StatefulWidget {
  const ProfilePasswordUpdateView({super.key});

  @override
  State<ProfilePasswordUpdateView> createState() =>
      _ProfilePasswordUpdateViewState();
}

class _ProfilePasswordUpdateViewState extends State<ProfilePasswordUpdateView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeData = Theme.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.background),
        child: ListView(children: const [
          SizedBox(height: 80),
          CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [ProfilePasswordUpdateForm()]))
        ]));
  }
}
