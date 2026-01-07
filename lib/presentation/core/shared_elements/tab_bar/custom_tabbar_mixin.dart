import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'custom_tab.dart';
import 'custom_tabbar.dart';

mixin CustomTabBarMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late TabController tabController;
  String currentRoute = '';

  List<CustomTabItem> get tabs;

  int get currentIndex {
    final index = tabs.indexWhere((tab) => tab.route == currentRoute);
    return index >= 0 ? index : 0;
  }

  Widget get currentContent {
    final tab = tabs.firstWhere(
      (tab) => tab.route == currentRoute,
      orElse: () => tabs.first,
    );
    return tab.content ?? Container();
  }

  void initializeTabController() {
    currentRoute = Modular.to.path;
    tabController = TabController(length: tabs.length, vsync: this);
    updateTabController();
  }

  void updateTabController() {
    final index = currentIndex;
    if (tabController.index != index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && tabController.index != index) {
          tabController.animateTo(index);
        }
      });
    }
  }

  void onTabTap(int index) {
    final route = tabs[index].route;
    if (route != null) {
      Modular.to.navigate(route);
      if (mounted) {
        setState(() {
          currentRoute = route;
        });
      }
    }
  }

  Widget buildTab(CustomTabItem tabItem, BuildContext context,
      ResponsiveBreakpointsData responsiveValue, double? availableWidth) {
    return CustomTab(
      title: tabItem.title,
      icon: tabItem.icon,
      responsiveValue: responsiveValue,
      availableWidth: availableWidth,
      totalTabs: tabs.length,
    );
  }

  Widget buildAnimatedContent() {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
            )),
            child: child,
          );
        },
        child: Container(
          key: ValueKey(currentRoute),
          child: currentContent,
        ),
      ),
    );
  }

  void updateTabsIfChanged(List<CustomTabItem> oldTabs) {
    if (oldTabs.length != tabs.length) {
      tabController.dispose();
      tabController = TabController(length: tabs.length, vsync: this);
    }
    updateTabController();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}