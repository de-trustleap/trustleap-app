import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_value.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_width_percentage_validator.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.mocks.dart';

class ValidatorTestModule extends Module {
  final PagebuilderBloc pagebuilderBloc;

  ValidatorTestModule(this.pagebuilderBloc);

  @override
  void binds(Injector i) {
    i.add<PagebuilderBloc>(() => pagebuilderBloc);
  }
}

void main() {
  group('PagebuilderWidthPercentageValidator', () {
    late PagebuilderBloc pagebuilderBloc;

    setUp(() {
      pagebuilderBloc = PagebuilderBloc(
        landingPageRepo: MockLandingPageRepository(),
        pageBuilderRepo: MockPagebuilderRepository(),
        userRepo: MockUserRepository(),
      );
      Modular.init(ValidatorTestModule(pagebuilderBloc));
    });

    tearDown(() {
      Modular.destroy();
    });

    group('findParentRow', () {
      test('should return null when widget has no widthPercentage', () {
        // Given
        final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('widget-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: widget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.findParentRow();

        // Then
        expect(result, isNull);
      });

      test('should return null when state is not GetLandingPageAndUserSuccessState', () {
        // Given
        final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('widget-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(50),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: widget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.findParentRow();

        // Then
        expect(result, isNull);
      });

      test('should find parent row when widget is child of row', () {
        // Given
        final childWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(50),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [childWidget],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [rowWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: childWidget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.findParentRow();

        // Then
        expect(result, isNotNull);
        expect(result!.id.value, equals('row-1'));
        expect(result.elementType, equals(PageBuilderWidgetType.row));
      });

      test('should find parent row in nested structure', () {
        // Given
        final childWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [childWidget],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final columnWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('column-1'),
          elementType: PageBuilderWidgetType.column,
          properties: null,
          hoverProperties: null,
          children: [rowWidget],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [columnWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: childWidget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.findParentRow();

        // Then
        expect(result, isNotNull);
        expect(result!.id.value, equals('row-1'));
      });

      test('should find parent row when widget is in containerChild', () {
        // Given
        final containerChild = PageBuilderWidget(
          id: UniqueID.fromUniqueString('container-child'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(40),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final containerWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('container-1'),
          elementType: PageBuilderWidgetType.container,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: containerChild,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [containerWidget],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [rowWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: containerChild,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.findParentRow();

        // Then
        expect(result, isNotNull);
        expect(result!.id.value, equals('row-1'));
      });

      test('should return null when widget is not in a row', () {
        // Given
        final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('widget-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(50),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final columnWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('column-1'),
          elementType: PageBuilderWidgetType.column,
          properties: null,
          hoverProperties: null,
          children: [widget],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [columnWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: widget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.findParentRow();

        // Then
        expect(result, isNull);
      });
    });

    group('calculateTotalWidthPercentage', () {
      test('should return null when parentRow is null', () {
        // Given
        final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('widget-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(50),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: widget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.calculateTotalWidthPercentage(
            null, PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, isNull);
      });

      test('should return null when row has no children', () {
        // Given
        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('widget-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(50),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: widget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.calculateTotalWidthPercentage(
            rowWidget, PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, isNull);
      });

      test('should calculate total width for desktop breakpoint', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(40),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.calculateTotalWidthPercentage(
            rowWidget, PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, equals(70));
      });

      test('should calculate total width for responsive values', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: PagebuilderResponsiveOrConstant.responsive({
            'desktop': 30,
            'tablet': 50,
            'mobile': 100,
          }),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: PagebuilderResponsiveOrConstant.responsive({
            'desktop': 40,
            'tablet': 50,
            'mobile': 100,
          }),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final desktopResult = validator.calculateTotalWidthPercentage(
            rowWidget, PagebuilderResponsiveBreakpoint.desktop);
        final tabletResult = validator.calculateTotalWidthPercentage(
            rowWidget, PagebuilderResponsiveBreakpoint.tablet);
        final mobileResult = validator.calculateTotalWidthPercentage(
            rowWidget, PagebuilderResponsiveBreakpoint.mobile);

        // Then
        expect(desktopResult, equals(70));
        expect(tabletResult, equals(100));
        expect(mobileResult, equals(200));
      });

      test('should handle children without widthPercentage', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(50),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result = validator.calculateTotalWidthPercentage(
            rowWidget, PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, equals(50));
      });
    });

    group('shouldShowWarning', () {
      test('should return false when total width is less than 100', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(40),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [rowWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result =
            validator.shouldShowWarning(PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, isFalse);
      });

      test('should return false when total width equals 100', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(60),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(40),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [rowWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result =
            validator.shouldShowWarning(PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, isFalse);
      });

      test('should return true when total width exceeds 100', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(70),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(60),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [rowWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result =
            validator.shouldShowWarning(PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, isTrue);
      });

      test('should handle different breakpoints correctly', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: PagebuilderResponsiveOrConstant.responsive({
            'desktop': 50,
            'tablet': 70,
            'mobile': 100,
          }),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: PagebuilderResponsiveOrConstant.responsive({
            'desktop': 40,
            'tablet': 50,
            'mobile': 100,
          }),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [rowWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final desktopWarning =
            validator.shouldShowWarning(PagebuilderResponsiveBreakpoint.desktop);
        final tabletWarning =
            validator.shouldShowWarning(PagebuilderResponsiveBreakpoint.tablet);
        final mobileWarning =
            validator.shouldShowWarning(PagebuilderResponsiveBreakpoint.mobile);

        // Then
        expect(desktopWarning, isFalse); // 90 total
        expect(tabletWarning, isTrue); // 120 total
        expect(mobileWarning, isTrue); // 200 total
      });
    });

    group('getTotalWidth', () {
      test('should return correct total width', () {
        // Given
        final child1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(35),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final child2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-2'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(45),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final rowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('row-1'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [child1, child2],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [rowWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: child1,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result =
            validator.getTotalWidth(PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, equals(80));
      });

      test('should return null when no parent row exists', () {
        // Given
        final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('widget-1'),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(50),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final columnWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('column-1'),
          elementType: PageBuilderWidgetType.column,
          properties: null,
          hoverProperties: null,
          children: [widget],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Test Section',
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [columnWidget],
          visibleOn: null,
        );

        final page = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-1'),
          sections: [section],
          backgroundColor: null,
        );

        final content = PagebuilderContent(
          landingPage: null,
          content: page,
          user: null,
        );

        pagebuilderBloc.emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: false,
          isUpdated: false,
        ));

        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: widget,
          pagebuilderBloc: pagebuilderBloc,
        );

        // When
        final result =
            validator.getTotalWidth(PagebuilderResponsiveBreakpoint.desktop);

        // Then
        expect(result, isNull);
      });
    });
  });
}
