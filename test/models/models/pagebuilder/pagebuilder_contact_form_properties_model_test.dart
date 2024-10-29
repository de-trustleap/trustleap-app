import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_contact_form_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderContactFormPropertiesModel_CopyWith", () {
    test(
        "set emailTextFieldProperties with copyWith should set emailTextFieldProperties for resulting object",
        () {
      // Given
      final model =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 400,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 400.0,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400,
        "minLines": 4,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200,
        "height": 70,
        "borderRadius": 4,
        "backgroundColor": "FF333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FFFFFFFF",
          "text": "NACHRICHT SENDEN"
        }
      });
      final expectedResult =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 400,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 200,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": null,
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400,
        "minLines": 4,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200,
        "height": 70,
        "borderRadius": 4,
        "backgroundColor": "FF333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FFFFFFFF",
          "text": "NACHRICHT SENDEN"
        }
      });
      // When
      final result = model.copyWith(emailTextFieldProperties: {
        "width": 200,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": null,
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      });
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContactFormPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 400,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 400.0,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400,
        "minLines": 4,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200,
        "height": 70,
        "borderRadius": 4,
        "backgroundColor": "FF333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FFFFFFFF",
          "text": "NACHRICHT SENDEN"
        }
      });
      final expectedResult = {
        "nameTextFieldProperties": {
          "width": 400,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihr Name"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto"
          }
        },
        "emailTextFieldProperties": {
          "width": 400.0,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre E-Mail"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto"
          }
        },
        "messageTextFieldProperties": {
          "width": 400,
          "minLines": 4,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre Nachricht"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto"
          }
        },
        "buttonProperties": {
          "width": 200,
          "height": 70,
          "borderRadius": 4,
          "backgroundColor": "FF333a56",
          "textProperties": {
            "alignment": "center",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FFFFFFFF",
            "text": "NACHRICHT SENDEN"
          }
        }
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContactFormPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "nameTextFieldProperties": {
          "width": 400,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihr Name"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto"
          }
        },
        "emailTextFieldProperties": {
          "width": 400.0,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre E-Mail"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto"
          }
        },
        "messageTextFieldProperties": {
          "width": 400,
          "minLines": 4,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre Nachricht"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16,
            "fontFamily": "Roboto"
          }
        },
        "buttonProperties": {
          "width": 200,
          "height": 70,
          "borderRadius": 4,
          "backgroundColor": "FF333a56",
          "textProperties": {
            "alignment": "center",
            "fontSize": 16,
            "fontFamily": "Roboto",
            "color": "FFFFFFFF",
            "text": "NACHRICHT SENDEN"
          }
        }
      };
      final expectedResult =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 400,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 400.0,
        "maxLines": 1,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400,
        "minLines": 4,
        "required": true,
        "backgroundColor": "FFF9F9F9",
        "borderColor": "FFDBDBDB",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200,
        "height": 70,
        "borderRadius": 4,
        "backgroundColor": "FF333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16,
          "fontFamily": "Roboto",
          "color": "FFFFFFFF",
          "text": "NACHRICHT SENDEN"
        }
      });
      // When
      final result = PageBuilderContactFormPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContactFormPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderContactFormPropertiesModel to PagebuilderContactFormProperties works",
        () {
      // Given
      final model =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 200.0,
        "minLines": 1,
        "isRequired": true,
        "backgroundColor": null,
        "borderColor": "FFF9F9F9",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "FF9A9A9C",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 400.0,
        "minLines": 1,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400.0,
        "minLines": 4,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200.0,
        "height": 70.0,
        "borderRadius": 4.0,
        "backgroundColor": "FF333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "FFFFFFFF",
          "text": "NACHRICHT SENDEN"
        }
      });
      final expectedResult = PageBuilderContactFormProperties(
          nameTextFieldProperties: PageBuilderTextFieldProperties(
              width: 200.0,
              minLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: Color(0xFFF9F9F9),
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihr Name",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: Color(0xFF9A9A9C),
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null)),
          emailTextFieldProperties: PageBuilderTextFieldProperties(
              width: 400.0,
              minLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre E-Mail",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null)),
          messageTextFieldProperties: PageBuilderTextFieldProperties(
              width: 400.0,
              minLines: 4,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre Nachricht",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null)),
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 70.0,
              borderRadius: 4,
              backgroundColor: Color(0xFF333a56),
              textProperties: PageBuilderTextProperties(
                  text: "NACHRICHT SENDEN",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: Colors.white,
                  alignment: TextAlign.center,
                  isBold: null,
                  isItalic: null)));
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContactFormPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderContactFormProperties to PagebuilderContactFormPropertiesModel works",
        () {
      // Given
      final model = PageBuilderContactFormProperties(
          nameTextFieldProperties: PageBuilderTextFieldProperties(
              width: 200.0,
              minLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: Color(0xFFF9F9F9),
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihr Name",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: Color(0xFF9A9A9C),
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null)),
          emailTextFieldProperties: PageBuilderTextFieldProperties(
              width: 400.0,
              minLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre E-Mail",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null)),
          messageTextFieldProperties: PageBuilderTextFieldProperties(
              width: 400.0,
              minLines: 4,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre Nachricht",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null)),
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 70.0,
              borderRadius: 4,
              backgroundColor: Color(0xFF333a56),
              textProperties: PageBuilderTextProperties(
                  text: "NACHRICHT SENDEN",
                  fontSize: 16.0,
                  fontFamily: "Roboto",
                  lineHeight: null,
                  color: Colors.white,
                  alignment: TextAlign.center,
                  isBold: null,
                  isItalic: null)));
      final expectedResult =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 200.0,
        "minLines": 1,
        "isRequired": true,
        "borderColor": "fff9f9f9",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "ff9a9a9c",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 400.0,
        "minLines": 1,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400.0,
        "minLines": 4,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200.0,
        "height": 70.0,
        "borderRadius": 4.0,
        "backgroundColor": "ff333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "ffffffff",
          "text": "NACHRICHT SENDEN"
        }
      });
      // When
      final result = PageBuilderContactFormPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContactFormPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 200.0,
        "minLines": 1,
        "isRequired": true,
        "borderColor": "fff9f9f9",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "ff9a9a9c",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 400.0,
        "minLines": 1,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400.0,
        "minLines": 4,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200.0,
        "height": 70.0,
        "borderRadius": 4.0,
        "backgroundColor": "ff333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "ffffffff",
          "text": "NACHRICHT SENDEN"
        }
      });
      final properties2 =
          PageBuilderContactFormPropertiesModel(nameTextFieldProperties: {
        "width": 200.0,
        "minLines": 1,
        "isRequired": true,
        "borderColor": "fff9f9f9",
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "ff9a9a9c",
          "text": "Ihr Name"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, emailTextFieldProperties: {
        "width": 400.0,
        "minLines": 1,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, messageTextFieldProperties: {
        "width": 400.0,
        "minLines": 4,
        "isRequired": true,
        "placeHolderTextProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "text": "Ihre Nachricht"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
          "fontFamily": "Roboto"
        }
      }, buttonProperties: {
        "width": 200.0,
        "height": 70.0,
        "borderRadius": 4.0,
        "backgroundColor": "ff333a56",
        "textProperties": {
          "alignment": "center",
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": "ffffffff",
          "text": "NACHRICHT SENDEN"
        }
      });
      // Then
      expect(properties1, properties2);
    });
  });
}



// TODO: JSON überprüfen wegen required statt isRequired und minLines statt maxLines und maxLines hinzufügen