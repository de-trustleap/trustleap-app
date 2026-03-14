import 'package:finanzbegleiter/core/refresh/native_refresh_notifier.dart';
import 'package:finanzbegleiter/core/refresh/refresh_scope.dart';
import 'package:finanzbegleiter/core/router_observer.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/custom_bottom_tabbar.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/native_appbar_override_scope.dart';
import 'package:finanzbegleiter/features/menu/presentation/appbar_native.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MobileAppTemplate extends StatefulWidget {
  const MobileAppTemplate({super.key});

  @override
  State<MobileAppTemplate> createState() => _MobileAppTemplateState();
}

class _MobileAppTemplateState extends State<MobileAppTemplate> {
  final NativeRefreshNotifier _refreshNotifier = NativeRefreshNotifier();
  final ValueNotifier<String?> _titleOverride = ValueNotifier(null);
  final ValueNotifier<List<Widget>?> _actionsOverride = ValueNotifier(null);
  final RouterOutletObserver _routerOutletObserver = RouterOutletObserver();
  int _baseHistoryLength = 0;

  static const List<String> _tabPaths = [
    RoutePaths.dashboardPath,
    RoutePaths.recommendationsPath,
    RoutePaths.recommendationManagerPath,
    RoutePaths.settingsPath,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.to.navigate(RoutePaths.homePath + RoutePaths.dashboardPath);
      setState(() {
        _baseHistoryLength = Modular.to.navigateHistory.length;
      });
    });
  }

  @override
  void dispose() {
    _refreshNotifier.dispose();
    _titleOverride.dispose();
    _actionsOverride.dispose();
    super.dispose();
  }

  int _getTabIndex(String path) {
    final index = _tabPaths.indexWhere((tab) =>
        path == RoutePaths.homePath + tab ||
        path.startsWith('${RoutePaths.homePath}$tab/'));
    return index >= 0 ? index : 0;
  }

  String _defaultTitle(
      String path, AppLocalizations l, List<String> tabLabels) {
    final tabIndex = _tabPaths.indexWhere((tab) =>
        path == RoutePaths.homePath + tab ||
        path.startsWith('${RoutePaths.homePath}$tab/'));
    if (tabIndex >= 0) return tabLabels[tabIndex];
    if (path.startsWith(RoutePaths.homePath + RoutePaths.profilePath)) {
      return l.menuitems_profile;
    }
    return '';
  }

  void _onTabSelected(int index) {
    Modular.to.navigate(RoutePaths.homePath + _tabPaths[index]);
  }

  void _openProfile() {
    Modular.to.pushNamed(RoutePaths.homePath + RoutePaths.profilePath);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    final tabLabels = [
      localization.menuitems_dashboard,
      localization.menuitems_recommendations,
      localization.menuitems_recommendation_manager,
      localization.settings_title,
    ];

    final profileButton = IconButton(
      icon: const Icon(Icons.person_outline),
      onPressed: _openProfile,
    );

    return ListenableBuilder(
      listenable:
          Listenable.merge([Modular.to, _titleOverride, _actionsOverride]),
      builder: (context, _) {
        final path = Modular.to.path;
        final canPop = Modular.to.navigateHistory.length > _baseHistoryLength;
        final isOnProfileRoute =
            path.startsWith(RoutePaths.homePath + RoutePaths.profilePath);

        return Scaffold(
          appBar: CustomAppBarNative(
            leading: canPop
                ? BackButton(
                    onPressed: () =>
                        _routerOutletObserver.navigator?.maybePop())
                : null,
            title: _titleOverride.value ??
                _defaultTitle(path, localization, tabLabels),
            actions: _actionsOverride.value ??
                (isOnProfileRoute ? null : [profileButton]),
          ),
          body: ScrollConfiguration(
            behavior: const _AlwaysScrollableBehavior(),
            child: RefreshIndicator.adaptive(
              onRefresh: () => _refreshNotifier.requestRefresh(),
              child: RefreshScope(
                notifier: _refreshNotifier,
                child: NativeAppBarOverrideScope(
                  titleOverride: _titleOverride,
                  actionsOverride: _actionsOverride,
                  child: RouterOutlet(
                    observers: [_routerOutletObserver],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomTabbar(
            selectedIndex: _getTabIndex(path),
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
      },
    );
  }
}

class _AlwaysScrollableBehavior extends ScrollBehavior {
  const _AlwaysScrollableBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      AlwaysScrollableScrollPhysics(parent: super.getScrollPhysics(context));
}
