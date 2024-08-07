import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/delete_account/profile_delete_account_form.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfileDeleteAccountView extends StatefulWidget {
  const ProfileDeleteAccountView({super.key});

  @override
  State<ProfileDeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<ProfileDeleteAccountView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.surface),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          const CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [ProfileDeleteAccountForm()]))
        ]));
  }
}
