import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration/register_promoters_form.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class RegisterPromotersView extends StatefulWidget {
  const RegisterPromotersView({super.key});

  @override
  State<RegisterPromotersView> createState() => _RegisterPromotersViewState();
}

class _RegisterPromotersViewState extends State<RegisterPromotersView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.background),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                RegisterPromotersForm(
                    changesSaved: () => {
                          CustomSnackBar.of(context).showCustomSnackBar(
                              localization.register_promoter_snackbar_success)
                        })
              ])),
        ]));
  }
}
