import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_edit/promoter_edit_form.dart';
import 'package:flutter/material.dart';

class PromoterEditPage extends StatelessWidget {
  final String promoterID;
  const PromoterEditPage({super.key, required this.promoterID});

  @override
  Widget build(BuildContext context) {
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
                  children: [PromoterEditForm(promoterID: promoterID)])),
        ]));
  }
}
