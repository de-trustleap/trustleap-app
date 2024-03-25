import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoters_overview_grid.dart';
import 'package:flutter/material.dart';

class PromotersOverview extends StatefulWidget {
  const PromotersOverview({super.key});

  @override
  State<PromotersOverview> createState() => _PromotersOverviewState();
}

class _PromotersOverviewState extends State<PromotersOverview>
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
        child: ListView(children: [
          const SizedBox(height: 80),
          CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [PromotersOverviewGrid()]))
        ]));
  }
}
