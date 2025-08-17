import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomTabItem {
  final String title;
  final IconData icon;
  final String route;
  final Widget content;

  const CustomTabItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.content,
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

class _CustomTabBarState extends State<CustomTabBar> with TickerProviderStateMixin {
  late TabController _tabController;

  String get currentRoute => Modular.to.path;

  int get currentIndex {
    final index = widget.tabs.indexWhere((tab) => tab.route == currentRoute);
    return index >= 0 ? index : 0;
  }

  Widget get currentContent {
    final tab = widget.tabs.firstWhere(
      (tab) => tab.route == currentRoute,
      orElse: () => widget.tabs.first,
    );
    return tab.content;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _updateTabController();
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabController.dispose();
      _tabController = TabController(length: widget.tabs.length, vsync: this);
    }
    _updateTabController();
  }

  void _updateTabController() {
    final index = currentIndex;
    if (_tabController.index != index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tabController.index != index) {
          _tabController.animateTo(index);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    final route = widget.tabs[index].route;
    Modular.to.navigate(route);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    
    return Column(
      children: [
        SizedBox(
          width: responsiveValue.screenWidth * 0.9,
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs.map((tab) => _buildTab(tab, context, responsiveValue)).toList(),
            onTap: _onTabTap,
            tabAlignment: responsiveValue.isMobile
                ? TabAlignment.start
                : TabAlignment.fill,
            isScrollable: responsiveValue.isMobile,
            indicatorPadding: const EdgeInsets.only(bottom: 4),
          ),
        ),
        Expanded(
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
        ),
      ],
    );
  }

  Widget _buildTab(CustomTabItem tabItem, BuildContext context, ResponsiveBreakpointsData responsiveValue) {
    
    return Tab(
      child: SizedBox(
        width: responsiveValue.isMobile ? 200 : 400,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: const Cubic(0.5, 0.8, 0.4, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  tabItem.icon,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceTint
                      .withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    tabItem.title,
                    style: responsiveValue.isMobile
                        ? Theme.of(context).textTheme.bodySmall
                        : Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}