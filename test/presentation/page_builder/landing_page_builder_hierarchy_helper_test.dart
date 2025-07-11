import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  group('LandingPageBuilderHierarchyHelper', () {
    late MockPagebuilderConfigMenuCubit mockConfigMenuCubit;
    late MockPagebuilderSelectionCubit mockSelectionCubit;
    late PageBuilderPage testPage;
    late LandingPageBuilderHierarchyHelper hierarchyHelper;

    setUp(() {
      mockConfigMenuCubit = MockPagebuilderConfigMenuCubit();
      mockSelectionCubit = MockPagebuilderSelectionCubit();
      
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
      );

      final testSection = PageBuilderSection(
        id: UniqueID.fromUniqueString('section-1'),
        layout: PageBuilderSectionLayout.column,
        background: null,
        maxWidth: null,
        widgets: [testWidget],
      );

      testPage = PageBuilderPage(
        id: UniqueID.fromUniqueString('page-1'),
        sections: [testSection],
        backgroundColor: null,
      );


      hierarchyHelper = LandingPageBuilderHierarchyHelper(
        page: testPage,
        configMenuCubit: mockConfigMenuCubit,
        selectionCubit: mockSelectionCubit,
      );
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
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-2'),
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          widgets: [parentWidget],
        );

        final pageWithNested = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-2'),
          sections: [section],
          backgroundColor: null,
        );

        final helperWithNested = LandingPageBuilderHierarchyHelper(
          page: pageWithNested,
          configMenuCubit: mockConfigMenuCubit,
          selectionCubit: mockSelectionCubit,
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
        );

        final section = PageBuilderSection(
          id: UniqueID.fromUniqueString('section-3'),
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          widgets: [containerWidget],
        );

        final pageWithContainer = PageBuilderPage(
          id: UniqueID.fromUniqueString('page-3'),
          sections: [section],
          backgroundColor: null,
        );

        final helperWithContainer = LandingPageBuilderHierarchyHelper(
          page: pageWithContainer,
          configMenuCubit: mockConfigMenuCubit,
          selectionCubit: mockSelectionCubit,
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
  });
}