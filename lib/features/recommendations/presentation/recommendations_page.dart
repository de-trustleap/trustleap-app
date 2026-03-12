import 'package:finanzbegleiter/core/refresh/refreshable_state_mixin.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendations_form.dart';
import 'package:flutter/material.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage>
    with RefreshableStateMixin {
  Key _contentKey = UniqueKey();

  @override
  Future<void> onRefresh() async {
    setState(() => _contentKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.surface),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 16 : 80),
          CenteredConstrainedWrapper(
            child: RecommendationsForm(key: _contentKey),
          ),
          SizedBox(height: responsiveValue.isMobile ? 16 : 80)
        ]));
  }
}
