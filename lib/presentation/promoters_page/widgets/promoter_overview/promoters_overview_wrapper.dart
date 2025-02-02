// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromotersOverviewWrapper extends StatefulWidget {
  final TabController? tabController;

  const PromotersOverviewWrapper({
    super.key,
    required this.tabController,
  });

  @override
  State<PromotersOverviewWrapper> createState() =>
      _PromotersOverviewWrapperState();
}

class _PromotersOverviewWrapperState extends State<PromotersOverviewWrapper>
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
          SizedBox(height: responsiveValue.isMobile ? 20 : 80),
          if (widget.tabController != null) ...[
            CenteredConstrainedWrapper(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  PromotersOverviewPage(tabController: widget.tabController!)
                ]))
          ]
        ]));
  }
}
