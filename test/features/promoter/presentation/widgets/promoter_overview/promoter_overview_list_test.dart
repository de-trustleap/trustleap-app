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
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_list.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../mocks.mocks.dart';

class PromoterOverviewListTestModule extends Module {
  final PermissionCubit permissionCubit;
  final PromoterObserverCubit promoterObserverCubit;

  PromoterOverviewListTestModule(
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
    String? email,
    bool isRegistered = true,
  }) {
    return Promoter(
      id: UniqueID.fromUniqueString(id ?? 'test-promoter-1'),
      firstName: firstName ?? 'John',
      lastName: lastName ?? 'Doe',
      email: email ?? 'test@example.com',
      registered: isRegistered,
    );
  }

  Widget createWidgetUnderTest({
    required List<Promoter> promoters,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = PromoterOverviewListTestModule(
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
            body: PromoterOverviewList(
              controller: ScrollController(),
              promoters: promoters,
            ),
          ),
        ),
      ),
    );
  }

  group('PromoterOverviewList Widget Tests', () {
    testWidgets('should render PromoterOverviewList widget', (tester) async {
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
      expect(find.byType(PromoterOverviewList), findsOneWidget);
    });

    testWidgets('should display list tiles for all promoters', (tester) async {
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
      expect(find.byType(PromoterOverviewListTile), findsNWidgets(3));
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

    testWidgets('should display promoter emails in tiles', (tester) async {
      // Given
      final promoters = [
        createTestPromoter(
            id: 'promoter-1',
            firstName: 'John',
            email: 'john@example.com'),
        createTestPromoter(
            id: 'promoter-2',
            firstName: 'Jane',
            email: 'jane@example.com'),
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
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
    });

    testWidgets('should be scrollable with ListView', (tester) async {
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

      // Then - verify ListView exists
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display correct number of list items', (tester) async {
      // Given
      final promoters = List.generate(
        5,
        (index) => createTestPromoter(id: 'promoter-$index'),
      );
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(promoters: promoters));
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewListTile), findsNWidgets(5));
    });
  });
}
