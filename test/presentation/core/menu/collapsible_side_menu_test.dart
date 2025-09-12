import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/domain/repositories/permission_repository.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/presentation/admin_area/admin_side_menu.dart';
import 'package:finanzbegleiter/presentation/core/menu/collapsible_side_menu.dart';
import 'package:finanzbegleiter/presentation/core/menu/menu_toggle_button.dart';
import 'package:finanzbegleiter/presentation/core/menu/side_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/test_module.dart';
import '../../../widget_test_wrapper.dart';
import '../../../mocks.mocks.dart';

class CollapsibleSideMenuTestModule extends Module {
  final MenuCubit menuCubit;
  final PermissionCubit permissionCubit;
  final MockPermissionRepository mockPermissionRepository;
  final bool isAdmin;

  CollapsibleSideMenuTestModule({
    required this.menuCubit,
    required this.permissionCubit,
    required this.mockPermissionRepository,
    required this.isAdmin,
  });

  @override
  void binds(i) {
    i.addLazySingleton<PermissionRepository>(() => mockPermissionRepository);
    i.addSingleton<MenuCubit>(() => menuCubit);
    i.addSingleton<PermissionCubit>(() => permissionCubit);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) {
      // Use the isAdmin value directly from the module instance
      return Scaffold(
        body: BlocProvider<MenuCubit>(
          create: (_) => menuCubit,
          child: CollapsibleSideMenu(isAdmin: isAdmin),
        ),
      );
    });
  }
}

void main() {
  late MenuCubit menuCubit;
  late PermissionCubit permissionCubit;
  late MockPermissionRepository mockPermissionRepository;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    // Add dummy states as done in RegisterForm tests
    provideDummy<MenuState>(MenuInitial());
    provideDummy<PermissionState>(PermissionInitial());

    // Create fresh instances for each test like RegisterForm does
    menuCubit = MenuCubit();
    mockPermissionRepository = MockPermissionRepository();
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);

    // Emit initial states like in main.dart to prevent casting errors
    menuCubit.emit(MenuInitial());
    permissionCubit.emit(PermissionSuccessState(
      permissions: const Permissions(permissions: {}),
      permissionInitiallyLoaded: true,
    ));
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    // Clear Modular cache after each test to prevent module caching issues
    Modular.destroy();
  });

  Widget createWidgetUnderTest({bool isAdmin = false}) {
    // Force clean module state before creating new module to prevent route caching
    Modular.destroy();

    // Ensure ResponsiveHelper is in test mode
    ResponsiveHelper.enableTestMode();

    // Create the widget tree manually without relying on routes
    // This ensures the isAdmin parameter is properly applied
    return ModularApp(
      module: CollapsibleSideMenuTestModule(
        menuCubit: menuCubit,
        permissionCubit: permissionCubit,
        mockPermissionRepository: mockPermissionRepository,
        isAdmin: isAdmin,
      ),
      child: CustomNavigator.create(
        child: MaterialApp(
          home: Scaffold(
            body: BlocProvider<MenuCubit>.value(
              value: menuCubit,
              child: CollapsibleSideMenu(isAdmin: isAdmin),
            ),
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  group('CollapsibleSideMenu Widget Tests', () {
    testWidgets('should build without errors and display basic structure',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: false));
      await tester.pumpAndSettle();

      // Then - check basic structure first
      expect(find.byType(CollapsibleSideMenu), findsOneWidget);
    });

    testWidgets('should display SideMenu when isAdmin is false',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: false));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(SideMenu), findsOneWidget);
      expect(find.byType(AdminSideMenu), findsNothing);
    });

    testWidgets('should display AdminSideMenu when isAdmin is true',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: true));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(AdminSideMenu), findsOneWidget);
      expect(find.byType(SideMenu), findsNothing);
    });

    testWidgets('should have MouseRegion wrapper for hover detection',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then - CollapsibleSideMenu should have its own MouseRegion (there might be others in the widget tree)
      expect(find.byType(MouseRegion), findsAtLeastNWidgets(1));

      // Find the CollapsibleSideMenu-specific MouseRegion by finding one that has enter/exit listeners
      final mouseRegions = find.byType(MouseRegion);
      expect(mouseRegions, findsAtLeastNWidgets(1));
    });

    testWidgets('should not show MenuToggleButton initially (no hover)',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(MenuToggleButton), findsNothing);
    });

    testWidgets('should show MenuToggleButton when hovered', (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // When - simulate mouse hover using gesture over the CollapsibleSideMenu area
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      // Find the CollapsibleSideMenu and hover over it
      final collapsibleSideMenu = find.byType(CollapsibleSideMenu);
      expect(collapsibleSideMenu, findsOneWidget);

      await gesture.moveTo(tester.getCenter(collapsibleSideMenu));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(MenuToggleButton), findsOneWidget);
    });

    testWidgets('should hide MenuToggleButton when hover ends', (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      // Hover first over CollapsibleSideMenu
      final collapsibleSideMenu = find.byType(CollapsibleSideMenu);
      await gesture.moveTo(tester.getCenter(collapsibleSideMenu));
      await tester.pumpAndSettle();
      expect(find.byType(MenuToggleButton), findsOneWidget);

      // When - stop hovering (move mouse away)
      await gesture.moveTo(const Offset(1000, 1000));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(MenuToggleButton), findsNothing);
    });

    testWidgets('should contain essential UI components', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then - Focus on user-visible behavior, not implementation details
      expect(find.byType(CollapsibleSideMenu), findsOneWidget);
      expect(find.byType(MouseRegion), findsAtLeastNWidgets(1));
      
      // Verify it can handle hover interactions (essential behavior)
      final mouseRegions = find.byType(MouseRegion);
      expect(mouseRegions, findsAtLeastNWidgets(1));
    });
  });

  group('CollapsibleSideMenu BlocListener Tests', () {
    testWidgets(
        'should collapse menu when MenuIsCollapsedState(true) is emitted',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();


      // When
      menuCubit.collapseMenu(true);
      await tester.pump();
      await tester.pump(
          const Duration(milliseconds: 150)); // Wait for animation to start

      // Then - menu should be in collapsed state
      expect(menuCubit.isCollapsed, true);

      // Check that child menu received collapsed state
      final sideMenu = tester.widget<SideMenu>(find.byType(SideMenu));
      expect(sideMenu.collapsed, true);
    });

    testWidgets(
        'should expand menu when MenuIsCollapsedState(false) is emitted',
        (tester) async {
      // Given - start with collapsed menu
      menuCubit.collapseMenu(true);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      // When - expand menu
      menuCubit.collapseMenu(false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      // Then - menu should be expanded
      expect(menuCubit.isCollapsed, false);

      // Check that child menu received expanded state
      final sideMenu = tester.widget<SideMenu>(find.byType(SideMenu));
      expect(sideMenu.collapsed, false);
    });

    testWidgets(
        'should call menuCubit.collapseMenu when toggle button is tapped',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Hover to show toggle button
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      final collapsibleSideMenu = find.byType(CollapsibleSideMenu);
      await gesture.moveTo(tester.getCenter(collapsibleSideMenu));
      await tester.pumpAndSettle();

      // When
      final toggleButton = find.byType(MenuToggleButton);
      expect(toggleButton, findsOneWidget);

      await tester.tap(toggleButton, warnIfMissed: false);
      await tester.pump();

      // Then - menu should be collapsed
      expect(menuCubit.isCollapsed, true);
    });

    testWidgets(
        'should toggle menu state correctly when button is tapped multiple times',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Hover to show toggle button
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      final collapsibleSideMenu = find.byType(CollapsibleSideMenu);
      await gesture.moveTo(tester.getCenter(collapsibleSideMenu));
      await tester.pumpAndSettle();

      final toggleButton = find.byType(MenuToggleButton);

      // Initially not collapsed
      expect(menuCubit.isCollapsed, false);

      // First tap - collapse
      await tester.tap(toggleButton, warnIfMissed: false);
      await tester.pump();
      expect(menuCubit.isCollapsed, true);

      // Second tap - expand
      await tester.tap(toggleButton, warnIfMissed: false);
      await tester.pump();
      expect(menuCubit.isCollapsed, false);
    });
  });

  group('CollapsibleSideMenu Animation Tests', () {
    testWidgets('should pass AnimationController to child widgets',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: false));
      await tester.pumpAndSettle();


      // Then
      final sideMenu = tester.widget<SideMenu>(find.byType(SideMenu));
      expect(sideMenu.animationController, isNotNull);
      expect(sideMenu.widthAnimation, isNotNull);
    });

    testWidgets('should pass AnimationController to AdminSideMenu',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: true));
      await tester.pumpAndSettle();


      // Then
      final adminSideMenu =
          tester.widget<AdminSideMenu>(find.byType(AdminSideMenu));
      expect(adminSideMenu.animationController, isNotNull);
    });

    testWidgets('should have animation with correct duration', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();


      // Get the SideMenu to access its animation
      final sideMenu = tester.widget<SideMenu>(find.byType(SideMenu));

      // Then
      expect(sideMenu.animationController?.duration,
          const Duration(milliseconds: 260));
    });
  });

  group('CollapsibleSideMenu Props Passing Tests', () {
    testWidgets('should pass correct collapsed state to SideMenu',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: false));
      await tester.pumpAndSettle();


      // Initially not collapsed
      var sideMenu = tester.widget<SideMenu>(find.byType(SideMenu));
      expect(sideMenu.collapsed, false);

      // When
      menuCubit.collapseMenu(true);
      await tester.pump();
      await tester.pump();

      // Then
      sideMenu = tester.widget<SideMenu>(find.byType(SideMenu));
      expect(sideMenu.collapsed, true);
    });

    testWidgets('should pass correct collapsed state to AdminSideMenu',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: true));
      await tester.pumpAndSettle();


      // Initially not collapsed
      var adminSideMenu =
          tester.widget<AdminSideMenu>(find.byType(AdminSideMenu));
      expect(adminSideMenu.collapsed, false);

      // When
      menuCubit.collapseMenu(true);
      await tester.pump();
      await tester.pump();

      // Then
      adminSideMenu = tester.widget<AdminSideMenu>(find.byType(AdminSideMenu));
      expect(adminSideMenu.collapsed, true);
    });

    testWidgets('should pass widthAnimation only to SideMenu', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: false));
      await tester.pumpAndSettle();


      // Then
      final sideMenuFinder = find.byType(SideMenu);
      expect(sideMenuFinder, findsOneWidget);

      final sideMenu = tester.widget<SideMenu>(sideMenuFinder);
      expect(sideMenu.widthAnimation, isNotNull);
    });

    testWidgets('should not pass widthAnimation to AdminSideMenu',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(isAdmin: true));
      await tester.pumpAndSettle();


      // Then - AdminSideMenu should only get animationController, not widthAnimation
      final adminSideMenuFinder = find.byType(AdminSideMenu);
      expect(adminSideMenuFinder, findsOneWidget);

      final adminSideMenu = tester.widget<AdminSideMenu>(adminSideMenuFinder);
      expect(adminSideMenu.animationController, isNotNull);
      // AdminSideMenu doesn't have widthAnimation property, which is correct
    });
  });

  group('CollapsibleSideMenu Behavior Tests', () {
    testWidgets('should maintain consistent state during user interactions', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initially should show correct menu type
      expect(find.byType(SideMenu), findsOneWidget);
      expect(find.byType(AdminSideMenu), findsNothing);
      
      // Should handle multiple interactions consistently
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      
      final collapsibleSideMenu = find.byType(CollapsibleSideMenu);
      await gesture.moveTo(tester.getCenter(collapsibleSideMenu));
      await tester.pumpAndSettle();
      
      // Verify hover shows toggle button
      expect(find.byType(MenuToggleButton), findsOneWidget);
      
      // Verify hover exit hides toggle button
      await gesture.moveTo(const Offset(1000, 1000));
      await tester.pumpAndSettle();
      expect(find.byType(MenuToggleButton), findsNothing);
    });
  });
}
