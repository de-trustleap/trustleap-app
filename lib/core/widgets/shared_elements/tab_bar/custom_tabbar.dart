import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'custom_tabbar_mixin.dart';
import 'custom_tabbar_mobile.dart';

class CustomTabItem {
  final String title;
  final IconData icon;
  final String? route;
  final Widget? content;

  const CustomTabItem({
    required this.title,
    required this.icon,
    this.route,
    this.content,
  });
}

class CustomTabBar extends StatefulWidget {
  final List<CustomTabItem> tabs;

  const CustomTabBar({
    super.key,
    required this.tabs,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin, CustomTabBarMixin<CustomTabBar> {
  @override
  List<CustomTabItem> get tabs => widget.tabs;

  @override
  void initState() {
    super.initState();
    initializeTabController();
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateTabsIfChanged(oldWidget.tabs);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveHelper.of(context);
    if (responsiveValue.isMobile) {
      return CustomTabBarMobile(tabs: widget.tabs);
    }
    return _buildDesktopTabBar(context, responsiveValue);
  }

  Widget _buildDesktopTabBar(
      BuildContext context, ResponsiveBreakpointsData responsiveValue) {
    return Column(
      children: [
        const SizedBox(height: 32),
        SizedBox(
          width: responsiveValue.screenWidth * 0.9,
          child: TabBar(
            controller: tabController,
            tabs: widget.tabs
                .map((tab) => buildTab(tab, context, responsiveValue, null))
                .toList(),
            onTap: onTabTap,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorPadding: const EdgeInsets.only(bottom: 4),
            dividerColor: Colors.transparent,
            dividerHeight: 0,
          ),
        ),
        buildAnimatedContent(),
      ],
    );
  }
}
