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
    final responsiveValue = ResponsiveBreakpoints.of(context);
    if (responsiveValue.isMobile) {
      return CustomTabBarMobile(tabs: widget.tabs);
    }
    return _buildDesktopTabBar(context, responsiveValue);
  }

  Widget _buildDesktopTabBar(
      BuildContext context, ResponsiveBreakpointsData responsiveValue) {
    final themeData = Theme.of(context);

    return Container(
      color: themeData.colorScheme.onPrimaryContainer,
      child: Column(
        children: [
          SizedBox(height: responsiveValue.screenHeight * 0.02),
          SizedBox(
            width: responsiveValue.screenWidth * 0.9,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TabBar(
                  controller: tabController,
                  tabs: widget.tabs
                      .map((tab) => buildTab(
                          tab, context, responsiveValue, constraints.maxWidth))
                      .toList(),
                  onTap: onTabTap,
                  tabAlignment: TabAlignment.fill,
                  isScrollable: false,
                  indicatorPadding: const EdgeInsets.only(bottom: 4),
                  dividerColor: themeData.textTheme.bodyMedium!.color,
                  dividerHeight: 0.5,
                );
              },
            ),
          ),
          buildAnimatedContent(),
        ],
      ),
    );
  }
}
