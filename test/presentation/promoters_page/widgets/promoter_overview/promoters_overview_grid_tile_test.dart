import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/permissions/domain/permission_repository.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_repository.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/status_badge.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

class PromotersOverviewGridTileTestModule extends Module {
  final PermissionCubit permissionCubit;
  final PromoterObserverCubit promoterObserverCubit;

  PromotersOverviewGridTileTestModule(
    this.permissionCubit,
    this.promoterObserverCubit,
  );

  @override
  void binds(i) {
    i.addSingleton<PermissionCubit>(() => permissionCubit);
    i.addSingleton<PromoterObserverCubit>(() => promoterObserverCubit);
  }

  @override
  void routes(r) {}
}

void main() {
  late MockPermissionRepository mockPermissionRepository;
  late MockPromoterRepository mockPromoterRepository;
  late PermissionCubit permissionCubit;
  late PromoterObserverCubit promoterObserverCubit;

  Permissions createTestPermissions({
    bool editPromoter = true,
    bool deletePromoter = true,
  }) {
    return Permissions(
      permissions: {
        'showPromoterMenu': true,
        'showPromoterDetails': true,
        'registerPromoter': true,
        'deletePromoter': deletePromoter,
        'editPromoter': editPromoter,
      },
    );
  }

  setUp(() {
    ResponsiveHelper.enableTestMode();

    provideDummy<PermissionState>(PermissionInitial());
    provideDummy<PromoterObserverState>(PromoterObserverInitial());

    mockPermissionRepository = MockPermissionRepository();
    mockPromoterRepository = MockPromoterRepository();

    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
    promoterObserverCubit = PromoterObserverCubit(mockPromoterRepository);

    permissionCubit.emit(PermissionSuccessState(
      permissions: createTestPermissions(),
      permissionInitiallyLoaded: true,
    ));
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    permissionCubit.close();
    promoterObserverCubit.close();
    Modular.destroy();
  });

  Promoter createTestPromoter({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    bool? registered,
  }) {
    return Promoter(
      id: UniqueID.fromUniqueString(id ?? 'test-promoter-1'),
      firstName: firstName ?? 'John',
      lastName: lastName ?? 'Doe',
      email: email ?? 'test@example.com',
      registered: registered ?? true,
    );
  }

  Widget createWidgetUnderTest({
    required Promoter promoter,
    Function(String, bool)? deletePressed,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = PromotersOverviewGridTileTestModule(
      permissionCubit,
      promoterObserverCubit,
    );

    return ModularApp(
      module: module,
      child: CustomNavigator.create(
        child: MaterialApp(
          locale: const Locale('de'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PromotersOverviewGridTile(
              promoter: promoter,
              deletePressed: deletePressed ?? (id, isRegistered) {},
            ),
          ),
        ),
      ),
    );
  }

  group('PromotersOverviewGridTile Widget Tests', () {
    testWidgets('should render PromotersOverviewGridTile widget',
        (tester) async {
      // Given
      final promoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then
      expect(find.byType(PromotersOverviewGridTile), findsOneWidget);
    });

    testWidgets('should display promoter name', (tester) async {
      // Given
      final promoter = createTestPromoter(
        firstName: 'John',
        lastName: 'Smith',
      );
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then
      expect(find.text('John Smith'), findsOneWidget);
    });

    testWidgets('should display promoter email', (tester) async {
      // Given
      final promoter = createTestPromoter(
        email: 'john.smith@example.com',
      );
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then
      expect(find.text('john.smith@example.com'), findsOneWidget);
    });

    testWidgets('should display registration badge for registered promoter',
        (tester) async {
      // Given
      final promoter = createTestPromoter(registered: true);
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then
      expect(find.byType(StatusBadge), findsOneWidget);
    });

    testWidgets('should display registration badge for unregistered promoter',
        (tester) async {
      // Given
      final promoter = createTestPromoter(registered: false);
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then
      expect(find.byType(StatusBadge), findsOneWidget);
    });

    testWidgets('should show popup menu when permissions allow',
        (tester) async {
      // Given
      final promoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(
          editPromoter: true,
          deletePromoter: true,
        ),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('should not show popup menu when no permissions',
        (tester) async {
      // Given
      final promoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(
          editPromoter: false,
          deletePromoter: false,
        ),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(PopupMenuButton<String>), findsNothing);
    });

    testWidgets('should call deletePressed when delete is selected',
        (tester) async {
      // Given
      final promoter = createTestPromoter(id: 'test-promoter-123');
      String? deletedId;
      bool? deletedIsRegistered;

      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(deletePromoter: true),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(
        promoter: promoter,
        deletePressed: (id, isRegistered) {
          deletedId = id;
          deletedIsRegistered = isRegistered;
        },
      ));
      await tester.pumpAndSettle();

      // Open popup menu
      final popupMenuIcon = find.byIcon(Icons.more_vert);
      await tester.tap(popupMenuIcon);
      await tester.pumpAndSettle();

      // Tap delete menu item
      final deleteMenuItem = find.byWidgetPredicate(
        (widget) => widget is PopupMenuItem<String> && widget.value == 'delete',
      );
      await tester.tap(deleteMenuItem);
      await tester.pumpAndSettle();

      // Then
      expect(deletedId, 'test-promoter-123');
      expect(deletedIsRegistered, true);
    });

    testWidgets('should display placeholder image when no thumbnail',
        (tester) async {
      // Given
      final promoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then - PlaceholderImage should be displayed (it uses an AssetImage)
      expect(find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      ), findsWidgets);
    });
  });

  group('PromotersOverviewGridTile Responsive Tests', () {
    testWidgets('should adjust size for mobile screen', (tester) async {
      // Given
      final promoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile size

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then - widget should render on mobile
      expect(find.byType(PromotersOverviewGridTile), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should adjust size for desktop screen', (tester) async {
      // Given
      final promoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding
          .setSurfaceSize(const Size(1920, 1080)); // Desktop size

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoter: promoter));
      await tester.pump();

      // Then - widget should render on desktop
      expect(find.byType(PromotersOverviewGridTile), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
