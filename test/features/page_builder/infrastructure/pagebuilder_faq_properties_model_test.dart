import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_item.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_faq_properties_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("PageBuilderFaqPropertiesModel_ToMap", () {
    test("check if model with items and chevronColor is converted to map", () {
      // Given
      final model = PageBuilderFaqPropertiesModel(
        items: [
          {"question": "Q1", "answer": "A1"},
        ],
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: "FF000000",
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      final expectedResult = {
        "items": [
          {"question": "Q1", "answer": "A1"},
        ],
        "chevronColor": "FF000000",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with all null fields is converted to empty map", () {
      // Given
      const model = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      final expectedResult = <String, dynamic>{};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with paint fields is converted to map correctly", () {
      // Given
      final model = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: {"color": "FFFFFFFF"},
        answerBackgroundPaint: {"color": "FFF9F9F9"},
        borderPaint: {"color": "FFDBDBDB"},
      );
      final expectedResult = {
        "questionBackgroundPaint": {"color": "FFFFFFFF"},
        "answerBackgroundPaint": {"color": "FFF9F9F9"},
        "borderPaint": {"color": "FFDBDBDB"},
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderFaqPropertiesModel_FromMap", () {
    test("check if map with items and chevronColor is converted to model", () {
      // Given
      final map = <String, dynamic>{
        "items": [
          {"question": "Q1", "answer": "A1"},
        ],
        "chevronColor": "FF000000",
      };
      final expectedResult = PageBuilderFaqPropertiesModel(
        items: [
          {"question": "Q1", "answer": "A1"},
        ],
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: "FF000000",
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = PageBuilderFaqPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if empty map is converted to model with all null fields", () {
      // Given
      final map = <String, dynamic>{};
      const expectedResult = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = PageBuilderFaqPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with paint fields is converted to model correctly", () {
      // Given
      final map = <String, dynamic>{
        "questionBackgroundPaint": {"color": "FFFFFFFF"},
        "answerBackgroundPaint": {"color": "FFF9F9F9"},
        "borderPaint": {"color": "FFDBDBDB"},
      };
      final expectedResult = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: {"color": "FFFFFFFF"},
        answerBackgroundPaint: {"color": "FFF9F9F9"},
        borderPaint: {"color": "FFDBDBDB"},
      );
      // When
      final result = PageBuilderFaqPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderFaqPropertiesModel_ToDomain", () {
    test("check if model with items is converted to domain with FAQItems", () {
      // Given
      final model = PageBuilderFaqPropertiesModel(
        items: [
          {"question": "Was ist X?", "answer": "X ist Y."},
          {"question": "Wie geht Z?", "answer": "Z geht so."},
        ],
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result.items?.length, 2);
      expect(result.items?.first.question, "Was ist X?");
      expect(result.items?.first.answer, "X ist Y.");
      expect(result.items?.last.question, "Wie geht Z?");
      expect(result.items?.last.answer, "Z geht so.");
    });

    test("check if model with null items produces domain with null items", () {
      // Given
      const model = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result.items, isNull);
    });

    test("check if chevronColor hex string is converted to Color", () {
      // Given
      final model = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: "FF000000",
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result.chevronColor, const Color(0xFF000000));
    });

    test("check if null chevronColor produces null Color in domain", () {
      // Given
      const model = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result.chevronColor, isNull);
    });

    test("check if paint fields are converted to domain", () {
      // Given
      final model = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: {"color": "FFFFFFFF"},
        answerBackgroundPaint: {"color": "FFF9F9F9"},
        borderPaint: {"color": "FFDBDBDB"},
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result.questionBackgroundPaint, isA<PagebuilderPaint>());
      expect(result.answerBackgroundPaint, isA<PagebuilderPaint>());
      expect(result.borderPaint, isA<PagebuilderPaint>());
    });

    test("check if all null fields produce domain with all null fields", () {
      // Given
      const model = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result.items, isNull);
      expect(result.questionTextProperties, isNull);
      expect(result.answerTextProperties, isNull);
      expect(result.chevronColor, isNull);
      expect(result.questionBackgroundPaint, isNull);
      expect(result.answerBackgroundPaint, isNull);
      expect(result.borderPaint, isNull);
    });
  });

  group("PageBuilderFaqPropertiesModel_FromDomain", () {
    test("check if domain with items is converted to model with item maps", () {
      // Given
      const domain = PageBuilderFaqProperties(
        items: [
          PagebuilderFAQItem(question: "Q1", answer: "A1"),
          PagebuilderFAQItem(question: "Q2", answer: "A2"),
        ],
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = PageBuilderFaqPropertiesModel.fromDomain(domain);
      // Then
      expect(result.items?.length, 2);
      expect(result.items?.first["question"], "Q1");
      expect(result.items?.first["answer"], "A1");
      expect(result.items?.last["question"], "Q2");
      expect(result.items?.last["answer"], "A2");
    });

    test("check if domain with null items produces model with null items", () {
      // Given
      const domain = PageBuilderFaqProperties(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = PageBuilderFaqPropertiesModel.fromDomain(domain);
      // Then
      expect(result.items, isNull);
    });

    test("check if FAQItem with null fields is serialized without those keys", () {
      // Given
      const domain = PageBuilderFaqProperties(
        items: [
          PagebuilderFAQItem(question: null, answer: null),
        ],
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = PageBuilderFaqPropertiesModel.fromDomain(domain);
      // Then
      expect(result.items?.first.containsKey("question"), isFalse);
      expect(result.items?.first.containsKey("answer"), isFalse);
    });

    test("check if all null domain fields produce model with all null fields", () {
      // Given
      const domain = PageBuilderFaqProperties(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // When
      final result = PageBuilderFaqPropertiesModel.fromDomain(domain);
      // Then
      expect(result.items, isNull);
      expect(result.questionTextProperties, isNull);
      expect(result.answerTextProperties, isNull);
      expect(result.chevronColor, isNull);
      expect(result.questionBackgroundPaint, isNull);
      expect(result.answerBackgroundPaint, isNull);
      expect(result.borderPaint, isNull);
    });
  });

  group("PageBuilderFaqPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final model1 = PageBuilderFaqPropertiesModel(
        items: [
          {"question": "Q1", "answer": "A1"},
        ],
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: "FF000000",
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      final model2 = PageBuilderFaqPropertiesModel(
        items: [
          {"question": "Q1", "answer": "A1"},
        ],
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: "FF000000",
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // Then
      expect(model1, model2);
    });

    test("check if inequality works with different chevronColor", () {
      // Given
      const model1 = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: "FF000000",
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      const model2 = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: "FFFFFFFF",
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if equality works with all null fields", () {
      // Given
      const model1 = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      const model2 = PageBuilderFaqPropertiesModel(
        items: null,
        questionTextProperties: null,
        answerTextProperties: null,
        chevronColor: null,
        questionBackgroundPaint: null,
        answerBackgroundPaint: null,
        borderPaint: null,
      );
      // Then
      expect(model1, model2);
    });
  });
}
