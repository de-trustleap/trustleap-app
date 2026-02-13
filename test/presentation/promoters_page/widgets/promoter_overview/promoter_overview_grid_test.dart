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
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_grid.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

class PromoterOverviewGridTestModule extends Module {
  final PermissionCubit permissionCubit;
  final PromoterObserverCubit promoterObserverCubit;

  PromoterOverviewGridTestModule(
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

  Permissions createTestPermissions() {
    return Permissions(
      permissions: {
        'showPromoterMenu': true,
        'showPromoterDetails': true,
        'registerPromoter': true,
        'deletePromoter': true,
        'editPromoter': true,
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
    bool isRegistered = true,
  }) {
    return Promoter(
      id: UniqueID.fromUniqueString(id ?? 'test-promoter-1'),
      firstName: firstName ?? 'John',
      lastName: lastName ?? 'Doe',
      email: 'test@example.com',
      registered: isRegistered,
    );
  }

  Widget createWidgetUnderTest({
    required List<Promoter> promoters,
    Function(String, bool)? deletePressed,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = PromoterOverviewGridTestModule(
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
            body: PromoterOverviewGrid(
              controller: ScrollController(),
              promoters: promoters,
              deletePressed: deletePressed ?? (id, isRegistered) {},
            ),
          ),
        ),
      ),
    );
  }

  group('PromoterOverviewGrid Widget Tests', () {
    testWidgets('should render PromoterOverviewGrid widget', (tester) async {
      // Given
      final promoters = [createTestPromoter()];
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoters: promoters));
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewGrid), findsOneWidget);
    });

    testWidgets('should display grid tiles for all promoters', (tester) async {
      // Given
      final promoters = [
        createTestPromoter(id: 'promoter-1', firstName: 'John'),
        createTestPromoter(id: 'promoter-2', firstName: 'Jane'),
        createTestPromoter(id: 'promoter-3', firstName: 'Bob'),
      ];
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoters: promoters));
      await tester.pump();

      // Then
      expect(find.byType(PromotersOverviewGridTile), findsNWidgets(3));
    });

    testWidgets('should display promoter names in tiles', (tester) async {
      // Given
      final promoters = [
        createTestPromoter(
            id: 'promoter-1', firstName: 'John', lastName: 'Smith'),
        createTestPromoter(
            id: 'promoter-2', firstName: 'Jane', lastName: 'Doe'),
      ];
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoters: promoters));
      await tester.pump();

      // Then
      expect(find.text('John Smith'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
    });

    testWidgets('should call deletePressed callback when delete is triggered',
        (tester) async {
      // Given
      final promoters = [createTestPromoter(id: 'test-id-1')];
      String? deletedId;
      bool? deletedIsRegistered;
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(
        promoters: promoters,
        deletePressed: (id, isRegistered) {
          deletedId = id;
          deletedIsRegistered = isRegistered;
        },
      ));
      await tester.pumpAndSettle();

      // Find and tap the PopupMenuButton icon (three dots)
      final popupMenuIcon = find.byIcon(Icons.more_vert);
      expect(popupMenuIcon, findsOneWidget);
      await tester.tap(popupMenuIcon);
      await tester.pumpAndSettle();

      // Find and tap the delete menu item by finding the PopupMenuItem with value "delete"
      final deleteMenuItem = find.byWidgetPredicate(
        (widget) => widget is PopupMenuItem<String> && widget.value == 'delete',
      );
      await tester.tap(deleteMenuItem);
      await tester.pumpAndSettle();

      // Then
      expect(deletedId, 'test-id-1');
      expect(deletedIsRegistered, true);
    });

    testWidgets('should be scrollable', (tester) async {
      // Given
      final promoters = List.generate(
        20,
        (index) => createTestPromoter(
          id: 'promoter-$index',
          firstName: 'Promoter',
          lastName: '$index',
        ),
      );
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoters: promoters));
      await tester.pump();

      // Then - verify SingleChildScrollView exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('PromoterOverviewGrid Responsive Tests', () {
    testWidgets('should adjust layout for mobile screen', (tester) async {
      // Given
      final promoters = [
        createTestPromoter(id: 'promoter-1'),
        createTestPromoter(id: 'promoter-2'),
      ];
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile size

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoters: promoters));
      await tester.pump();

      // Then - verify tiles are displayed (responsive behavior is internal)
      expect(find.byType(PromotersOverviewGridTile), findsNWidgets(2));
    });

    testWidgets('should adjust layout for desktop screen', (tester) async {
      // Given
      final promoters = List.generate(
        6,
        (index) => createTestPromoter(id: 'promoter-$index'),
      );
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding
          .setSurfaceSize(const Size(1920, 1080)); // Desktop size

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoters: promoters));
      await tester.pump();

      // Then - verify all tiles are displayed
      expect(find.byType(PromotersOverviewGridTile), findsNWidgets(6));
    });
  });
}
