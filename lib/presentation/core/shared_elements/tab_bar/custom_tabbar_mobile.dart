import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'custom_tabbar.dart';
import 'custom_tabbar_mixin.dart';

class CustomTabBarMobile extends StatefulWidget {
  final List<CustomTabItem> tabs;

  const CustomTabBarMobile({
    super.key,
    required this.tabs,
  });

  @override
  State<CustomTabBarMobile> createState() => _CustomTabBarMobileState();
}

class _CustomTabBarMobileState extends State<CustomTabBarMobile>
    with TickerProviderStateMixin, CustomTabBarMixin<CustomTabBarMobile> {
  bool _showLeftChevron = false;
  bool _showRightChevron = false;
  ScrollController? _scrollController;

  @override
  List<CustomTabItem> get tabs => widget.tabs;

  @override
  void initState() {
    super.initState();
    initializeTabController();

    if (widget.tabs.length > 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setupScrollListener();
      });
    }
  }

  @override
  void dispose() {
    if (widget.tabs.length > 3) {
      tabController.removeListener(_updateScrollIndicators);
    }
    _scrollController?.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    tabController.addListener(_updateScrollIndicators);
    _updateScrollIndicators();
  }

  void _updateScrollIndicators() {
    if (!mounted || widget.tabs.length <= 3) return;

    final currentIndex = tabController.index;
    final tabCount = widget.tabs.length;

    setState(() {
      _showLeftChevron = currentIndex > 0;
      _showRightChevron = currentIndex < tabCount - 1;
    });
  }

  @override
  void didUpdateWidget(CustomTabBarMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateTabsIfChanged(oldWidget.tabs);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
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
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: _showLeftChevron ? 24.0 : 0.0,
                        right: _showRightChevron ? 24.0 : 0.0,
                      ),
                      child: TabBar(
                        controller: tabController,
                        tabs: widget.tabs
                            .map((tab) => buildTab(
                                tab,
                                context,
                                responsiveValue,
                                constraints.maxWidth -
                                    (_showLeftChevron ? 24 : 0) -
                                    (_showRightChevron ? 24 : 0)))
                            .toList(),
                        onTap: onTabTap,
                        tabAlignment: widget.tabs.length > 3
                            ? TabAlignment.start
                            : TabAlignment.fill,
                        isScrollable: widget.tabs.length > 3,
                        indicatorPadding: const EdgeInsets.only(bottom: 4),
                        dividerColor: themeData.textTheme.bodyMedium!.color,
                        dividerHeight: 0.5,
                      ),
                    ),
                    if (_showLeftChevron) ...[
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: Container(
                            width: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  themeData.colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.0),
                                  themeData.colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.9),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.chevron_left,
                                size: 16,
                                color: themeData.colorScheme.surfaceTint
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_showRightChevron) ...[
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: Container(
                            width: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  themeData.colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.0),
                                  themeData.colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.9),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: themeData.colorScheme.surfaceTint
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
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
