import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_registration/register_promoters_form.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterPromotersView extends StatefulWidget {
  final Function newPromoterCreated;
  const RegisterPromotersView({super.key, required this.newPromoterCreated});

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
    final responsiveValue = ResponsiveHelper.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.surface),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                RegisterPromotersForm(changesSaved: () {
                  Modular.to.navigate(
                      "${RoutePaths.homePath}${RoutePaths.promotersPath}${RoutePaths.promotersOverviewPath}");
                  widget.newPromoterCreated();
                })
              ])),
        ]));
  }
}
