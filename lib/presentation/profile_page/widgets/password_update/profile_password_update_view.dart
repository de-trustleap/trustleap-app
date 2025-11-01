import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
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
    final responsiveValue = ResponsiveHelper.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.surface),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          const CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [ProfilePasswordUpdateForm()]))
        ]));
  }
}
