import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

class HierarchyHelperTestModule extends Module {
  final MockPagebuilderSelectionCubit selectionCubit;
  final MockPagebuilderConfigMenuCubit configMenuCubit;

  HierarchyHelperTestModule(this.selectionCubit, this.configMenuCubit);

  @override
  void binds(i) {
    i.addInstance<PagebuilderSelectionCubit>(selectionCubit);
    i.addInstance<PagebuilderConfigMenuCubit>(configMenuCubit);
  }

  @override
  void routes(r) {}
}

void main() {
  group('LandingPageBuilderHierarchyHelper', () {
    late MockPagebuilderConfigMenuCubit mockConfigMenuCubit;
    late MockPagebuilderSelectionCubit mockSelectionCubit;
    late PageBuilderPage testPage;
    late LandingPageBuilderHierarchyHelper hierarchyHelper;

    setUp(() {
      mockConfigMenuCubit = MockPagebuilderConfigMenuCubit();
      mockSelectionCubit = MockPagebuilderSelectionCubit();

      // Initialize Modular with test module
      Modular.init(HierarchyHelperTestModule(mockSelectionCubit, mockConfigMenuCubit));

      // Create test data
      final testWidget = PageBuilderWidget(
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

      final testSection = PageBuilderSection(
        id: UniqueID.fromUniqueString('section-1'),
        name: 'Test Section',
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
        widgets: [testWidget],
        visibleOn: null,
      );

      testPage = PageBuilderPage(
        id: UniqueID.fromUniqueString('page-1'),
        sections: [testSection],
        backgroundColor: null,
        globalStyles: null,
      );


      hierarchyHelper = LandingPageBuilderHierarchyHelper(
        page: testPage,
      );
    });

    tearDown(() {
      Modular.destroy();
    });

    group('findWidgetById', () {
      test('should find widget by id', () {
        // When
        final result = hierarchyHelper.findWidgetById('widget-1');

        // Then
        expect(result, isNotNull);
        expect(result!.id.value, equals('widget-1'));
      });

      test('should return null for non-existent widget id', () {
        // When
        final result = hierarchyHelper.findWidgetById('non-existent');

        // Then
        expect(result, isNull);
      });

      test('should find widget in nested children', () {
        // Given
        final childWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-widget'),
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

        final parentWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('parent-widget'),
          elementType: PageBuilderWidgetType.column,
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
          id: UniqueID.fromUniqueString('section-2'),
          name: 'Test Section 2',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [parentWidget],
          visibleOn: null,
        );

        final pageWithNested = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-2'),
          sections: [section],
          backgroundColor: null,
          globalStyles: null,
        );

        final helperWithNested = LandingPageBuilderHierarchyHelper(
          page: pageWithNested,
        );

        // When
        final result = helperWithNested.findWidgetById('child-widget');

        // Then
        expect(result, isNotNull);
        expect(result!.id.value, equals('child-widget'));
      });

      test('should find widget in containerChild', () {
        // Given
        final containerChild = PageBuilderWidget(
          id: UniqueID.fromUniqueString('container-child'),
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

        final containerWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('container-widget'),
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

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-3'),
          name: 'Test Section 3',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [containerWidget],
          visibleOn: null,
        );

        final pageWithContainer = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-3'),
          sections: [section],
          backgroundColor: null,
          globalStyles: null,
        );

        final helperWithContainer = LandingPageBuilderHierarchyHelper(
          page: pageWithContainer,
        );

        // When
        final result = helperWithContainer.findWidgetById('container-child');

        // Then
        expect(result, isNotNull);
        expect(result!.id.value, equals('container-child'));
      });
    });

    group('onHierarchyItemSelected', () {
      test('should select widget and open config menu for existing widget', () {
        // When
        hierarchyHelper.onHierarchyItemSelected('widget-1', false);

        // Then
        verify(mockSelectionCubit.selectWidget('widget-1')).called(1);
        verify(mockConfigMenuCubit.openConfigMenu(any)).called(1);
      });

      test('should select section and open section config menu for existing section', () {
        // When
        hierarchyHelper.onHierarchyItemSelected('section-1', true);

        // Then
        verify(mockSelectionCubit.selectWidget('section-1')).called(1);
        verify(mockConfigMenuCubit.openSectionConfigMenu(any)).called(1);
      });

      test('should select widget but not open config menu for non-existent widget', () {
        // When
        hierarchyHelper.onHierarchyItemSelected('non-existent', false);

        // Then
        verify(mockSelectionCubit.selectWidget('non-existent')).called(1);
        verifyNever(mockConfigMenuCubit.openConfigMenu(any));
      });
    });

    group('getExpansionPathForWidget', () {
      test('should return section path for section IDs', () {
        // When
        final result = hierarchyHelper.getExpansionPathForWidget('section-1');

        // Then
        expect(result['sections'], equals(['section-1']));
        expect(result['widgets'], isEmpty);
      });

      test('should return section expansion for top-level widget', () {
        // When
        final result = hierarchyHelper.getExpansionPathForWidget('widget-1');

        // Then
        expect(result['sections'], equals(['section-1']));
        expect(result['widgets'], isEmpty);
      });

      test('should return expansion path for nested widget', () {
        // Given
        final childWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('child-widget'),
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

        final parentWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('parent-widget'),
          elementType: PageBuilderWidgetType.column,
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
          id: UniqueID.fromUniqueString('test-section'),
          name: 'Nested Test Section',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [parentWidget],
          visibleOn: null,
        );

        final pageWithNested = PageBuilderPage(
          id: UniqueID.fromUniqueString('test-page'),
          sections: [section],
          backgroundColor: null,
          globalStyles: null,
        );

        final nestedHelper = LandingPageBuilderHierarchyHelper(
          page: pageWithNested,
        );

        // When
        final result = nestedHelper.getExpansionPathForWidget('child-widget');

        // Then
        expect(result['sections'], equals(['test-section']));
        expect(result['widgets'], equals(['parent-widget']));
      });

      test('should return expansion path for container child widget', () {
        // Given
        final containerChild = PageBuilderWidget(
          id: UniqueID.fromUniqueString('container-child'),
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

        final containerWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('container-widget'),
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

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('container-section'),
          name: 'Container Section',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [containerWidget],
          visibleOn: null,
        );

        final pageWithContainer = PageBuilderPage(
          id: UniqueID.fromUniqueString('container-page'),
          sections: [section],
          backgroundColor: null,
          globalStyles: null,
        );

        final containerHelper = LandingPageBuilderHierarchyHelper(
          page: pageWithContainer,
        );

        // When
        final result = containerHelper.getExpansionPathForWidget('container-child');

        // Then
        expect(result['sections'], equals(['container-section']));
        expect(result['widgets'], equals(['container-widget']));
      });

      test('should return empty paths for non-existent widget', () {
        // When
        final result = hierarchyHelper.getExpansionPathForWidget('non-existent');

        // Then
        expect(result['sections'], isEmpty);
        expect(result['widgets'], isEmpty);
      });

      test('should return correct path for deeply nested widget', () {
        // Given - Create a 3-level nested structure
        final deepChild = PageBuilderWidget(
          id: UniqueID.fromUniqueString('deep-child'),
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

        final middleWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('middle-widget'),
          elementType: PageBuilderWidgetType.row,
          properties: null,
          hoverProperties: null,
          children: [deepChild],
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

        final topWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString('top-widget'),
          elementType: PageBuilderWidgetType.column,
          properties: null,
          hoverProperties: null,
          children: [middleWidget],
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
          id: UniqueID.fromUniqueString('deep-section'),
          name: 'Deep Section',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [topWidget],
          visibleOn: null,
        );

        final deepPage = PageBuilderPage(
          id: UniqueID.fromUniqueString('deep-page'),
          sections: [section],
          backgroundColor: null,
          globalStyles: null,
        );

        final deepHelper = LandingPageBuilderHierarchyHelper(
          page: deepPage,
        );

        // When
        final result = deepHelper.getExpansionPathForWidget('deep-child');

        // Then
        expect(result['sections'], equals(['deep-section']));
        expect(result['widgets'], equals(['top-widget', 'middle-widget']));
      });
    });

    group('getOptimalExpansionState', () {
      test('should expand selected section without collapse information', () {
        // Given - Create a page with multiple sections
        final section1 = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-1'),
          name: 'Section 1',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [testPage.sections![0].widgets![0]], // Use existing widget
          visibleOn: null,
        );

        final section2 = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-2'),
          name: 'Section 2',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [],
          visibleOn: null,
        );

        final multiSectionPage = PageBuilderPage(
          id: UniqueID.fromUniqueString('multi-page'),
          sections: [section1, section2],
          backgroundColor: null,
          globalStyles: null,
        );

        final multiHelper = LandingPageBuilderHierarchyHelper(
          page: multiSectionPage,
        );

        // When
        final result = multiHelper.getOptimalExpansionState('section-1');

        // Then
        expect(result['sectionsToExpand'], equals(['section-1']));
        expect(result['sectionsToCollapse'], isEmpty);
        expect(result['widgetsToCollapse'], isEmpty);
      });

      test('should expand section for widget without collapse information', () {
        // Given - Create a page with multiple widgets in same section
        final widget1 = PageBuilderWidget(
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

        final widget2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString('widget-2'),
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

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('test-section'),
          name: 'Test Section with Widgets',
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
        customCSS: null,
      fullHeight: null,
          widgets: [widget1, widget2],
          visibleOn: null,
        );

        final testPage = PageBuilderPage(
          id: UniqueID.fromUniqueString('test-page'),
          sections: [section],
          backgroundColor: null,
          globalStyles: null,
        );

        final testHelper = LandingPageBuilderHierarchyHelper(
          page: testPage,
        );

        // When
        final result = testHelper.getOptimalExpansionState('widget-1');

        // Then
        expect(result['sectionsToExpand'], equals(['test-section']));
        expect(result['widgetsToExpand'], isEmpty);
        expect(result['widgetsToCollapse'], isEmpty);
      });
    });
  });
}