import 'package:finanzbegleiter/core/refresh/native_refresh_notifier.dart';
import 'package:finanzbegleiter/core/refresh/refresh_scope.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/custom_bottom_tabbar.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/dashboard_page.dart';
import 'package:finanzbegleiter/features/menu/presentation/appbar_native.dart';
import 'package:finanzbegleiter/features/profile/presentation/profile_page.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_page.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendations_page.dart';
import 'package:finanzbegleiter/features/settings/presentation/native_settings_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class MobileAppTemplate extends StatefulWidget {
  const MobileAppTemplate({super.key});

  @override
  State<MobileAppTemplate> createState() => _MobileAppTemplateState();
}

class _MobileAppTemplateState extends State<MobileAppTemplate> {
  int _currentIndex = 0;
  final Set<int> _visitedTabs = {0};
  final List<NativeRefreshNotifier> _refreshNotifiers =
      List.generate(4, (_) => NativeRefreshNotifier());

  static const int _tabCount = 4;

  @override
  void dispose() {
    for (final notifier in _refreshNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const RecommendationsPage();
      case 2:
        return const RecommendationManagerPage();
      case 3:
        return const NativeSettingsPage();
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _onRefresh() {
    return _refreshNotifiers[_currentIndex].requestRefresh();
  }

  void _onTabSelected(int index) {
    setState(() {
      _visitedTabs.add(index);
      _currentIndex = index;
    });
  }

  void _openProfile() {
    final localization = AppLocalizations.of(context);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: CustomAppBarNative(title: localization.menuitems_profile),
        body: const ProfilePage(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    final labels = [
      localization.menuitems_dashboard,
      localization.menuitems_recommendations,
      localization.menuitems_recommendation_manager,
      localization.settings_title,
    ];

    return Scaffold(
      appBar: CustomAppBarNative(
        title: labels[_currentIndex],
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: _openProfile,
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const _AlwaysScrollableBehavior(),
        child: RefreshIndicator.adaptive(
          onRefresh: _onRefresh,
          child: IndexedStack(
            index: _currentIndex,
            children: List.generate(_tabCount, (i) {
              if (!_visitedTabs.contains(i)) return const SizedBox.shrink();
              return RefreshScope(
                notifier: _refreshNotifiers[i],
                child: _buildPage(i),
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomTabbar(
        selectedIndex: _currentIndex,
        onTabSelected: _onTabSelected,
        items: [
          CustomBottomTabItem(
            icon: Icons.pie_chart_outline,
            selectedIcon: Icons.pie_chart,
            label: localization.menuitems_dashboard,
          ),
          CustomBottomTabItem(
            icon: Icons.lightbulb_outline,
            selectedIcon: Icons.lightbulb,
            label: localization.menuitems_recommendations,
          ),
          CustomBottomTabItem(
            icon: Icons.checklist_outlined,
            selectedIcon: Icons.checklist,
            label: localization.menuitems_manager,
          ),
          CustomBottomTabItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: localization.settings_title,
          ),
        ],
      ),
    );
  }
}

class _AlwaysScrollableBehavior extends ScrollBehavior {
  const _AlwaysScrollableBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
}
