import 'package:finanzbegleiter/core/refresh/refreshable_state_mixin.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_overview.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with RefreshableStateMixin {
  Key _contentKey = UniqueKey();

  @override
  Future<void> onRefresh() async {
    setState(() => _contentKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.surface),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 16 : 80),
          CenteredConstrainedWrapper(
            child: DashboardOverview(key: _contentKey),
          )
        ]));
  }
}
