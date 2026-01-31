import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_contact_form_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';

void main() {
  group("PagebuilderContactFormPropertiesModel_CopyWith", () {
    test(
        "set emailTextFieldProperties with copyWith should set emailTextFieldProperties for resulting object",
        () {
      // Given
      final model = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 400,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
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
          },
          emailTextFieldProperties: {
            "width": 400.0,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre E-Mail"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "maxLines": 1,
            "required": false,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Telefonnummer"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400,
            "minLines": 4,
            "maxLines": 5,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Nachricht"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          buttonProperties: {
            "width": 200,
            "height": 70,
            "border": {"radius": 4},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FFFFFFFF",
              "text": "NACHRICHT SENDEN"
            }
          });
      final expectedResult = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 400,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
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
          },
          emailTextFieldProperties: {
            "width": 200,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": null,
              "text": "Ihre E-Mail"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "maxLines": 1,
            "required": false,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Telefonnummer"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400,
            "minLines": 4,
            "maxLines": 5,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Nachricht"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          buttonProperties: {
            "width": 200,
            "height": 70,
            "border": {"radius": 4},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
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
          "fontSize": 16.0,
          "fontFamily": "Roboto",
          "color": null,
          "text": "Ihre E-Mail"
        },
        "textProperties": {
          "alignment": "left",
          "fontSize": 16.0,
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
      final model = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 400,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
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
          },
          emailTextFieldProperties: {
            "width": 400.0,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre E-Mail"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "maxLines": 1,
            "required": false,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Telefonnummer"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400,
            "minLines": 4,
            "maxLines": 5,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Nachricht"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          buttonProperties: {
            "width": 200,
            "height": 70,
            "border": {"radius": 4},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FFFFFFFF",
              "text": "NACHRICHT SENDEN"
            }
          });
      final expectedResult = {
        "email": "test@test.de",
        "nameTextFieldProperties": {
          "width": 400,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
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
        },
        "emailTextFieldProperties": {
          "width": 400.0,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre E-Mail"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto"
          }
        },
        "phoneTextFieldProperties": {
          "width": 400.0,
          "maxLines": 1,
          "required": false,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre Telefonnummer"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto"
          }
        },
        "messageTextFieldProperties": {
          "width": 400,
          "minLines": 4,
          "maxLines": 5,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre Nachricht"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto"
          }
        },
        "buttonProperties": {
          "width": 200,
          "height": 70,
          "border": {"radius": 4},
          "backgroundPaint": {"color": "FF333A56"},
          "textProperties": {
            "alignment": "center",
            "fontSize": 16.0,
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
        "email": "test@test.de",
        "nameTextFieldProperties": {
          "width": 400,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
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
        },
        "emailTextFieldProperties": {
          "width": 400.0,
          "maxLines": 1,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre E-Mail"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto"
          }
        },
        "phoneTextFieldProperties": {
          "width": 400.0,
          "maxLines": 1,
          "required": false,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre Telefonnummer"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto"
          }
        },
        "messageTextFieldProperties": {
          "width": 400,
          "minLines": 4,
          "maxLines": 5,
          "required": true,
          "backgroundColor": "FFF9F9F9",
          "borderColor": "FFDBDBDB",
          "placeHolderTextProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto",
            "color": "FF9A9A9C",
            "text": "Ihre Nachricht"
          },
          "textProperties": {
            "alignment": "left",
            "fontSize": 16.0,
            "fontFamily": "Roboto"
          }
        },
        "buttonProperties": {
          "width": 200,
          "height": 70,
          "border": {"radius": 4},
          "backgroundPaint": {"color": "FF333A56"},
          "textProperties": {
            "alignment": "center",
            "fontSize": 16.0,
            "fontFamily": "Roboto",
            "color": "FFFFFFFF",
            "text": "NACHRICHT SENDEN"
          }
        }
      };
      final expectedResult = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 400,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
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
          },
          emailTextFieldProperties: {
            "width": 400.0,
            "maxLines": 1,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre E-Mail"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "maxLines": 1,
            "required": false,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Telefonnummer"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400,
            "minLines": 4,
            "maxLines": 5,
            "required": true,
            "backgroundColor": "FFF9F9F9",
            "borderColor": "FFDBDBDB",
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FF9A9A9C",
              "text": "Ihre Nachricht"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          buttonProperties: {
            "width": 200,
            "height": 70,
            "border": {"radius": 4},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
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
      final model = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 200.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": true,
            "backgroundPaint": null,
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
          },
          emailTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
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
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": false,
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "text": "Ihre Telefonnummer"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400.0,
            "minLines": 4,
            "maxLines": 5,
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
          },
          buttonProperties: {
            "width": 200.0,
            "height": 70.0,
            "border": {"radius": 4.0},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FFFFFFFF",
              "text": "NACHRICHT SENDEN"
            }
          });
      final expectedResult = PageBuilderContactFormProperties(
          email: "test@test.de",
          nameTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(200.0),
              minLines: 1,
              maxLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: Color(0xFFF9F9F9),
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihr Name",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: Color(0xFF9A9A9C),
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          emailTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(400.0),
              minLines: 1,
              maxLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre E-Mail",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          phoneTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(400.0),
              minLines: 1,
              maxLines: 1,
              isRequired: false,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre Telefonnummer",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          messageTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(400.0),
              minLines: 4,
              maxLines: 5,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre Nachricht",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          buttonProperties: PageBuilderButtonProperties(
              sizeMode: null,
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(70.0),
              minWidthPercent: null,
              contentPadding: null,
              border: const PagebuilderBorder(radius: 4, width: null, color: null),
              backgroundPaint: const PagebuilderPaint.color(Color(0xFF333A56)),
              textProperties: PageBuilderTextProperties(
                  text: "NACHRICHT SENDEN",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: Colors.white,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center))));
      // When
      final result = model.toDomain(null);
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
          email: "test@test.de",
          nameTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(200.0),
              minLines: 1,
              maxLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: Color(0xFFF9F9F9),
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihr Name",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: Color(0xFF9A9A9C),
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          emailTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(400.0),
              minLines: 1,
              maxLines: 1,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre E-Mail",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          phoneTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(400.0),
              minLines: 1,
              maxLines: 1,
              isRequired: false,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre Telefonnummer",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          messageTextFieldProperties: const PageBuilderTextFieldProperties(
              width: PagebuilderResponsiveOrConstant.constant(400.0),
              minLines: 4,
              maxLines: 5,
              isRequired: true,
              backgroundColor: null,
              borderColor: null,
              placeHolderTextProperties: PageBuilderTextProperties(
                  text: "Ihre Nachricht",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
              textProperties: PageBuilderTextProperties(
                  text: null,
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left))),
          buttonProperties: PageBuilderButtonProperties(
              sizeMode: null,
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(70.0),
              minWidthPercent: null,
              contentPadding: null,
              border: const PagebuilderBorder(radius: 4, width: null, color: null),
              backgroundPaint: const PagebuilderPaint.color(Color(0xFF333A56)),
              textProperties: PageBuilderTextProperties(
                  text: "NACHRICHT SENDEN",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: "Roboto",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: Colors.white,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center))));
      final expectedResult = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 200.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": true,
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
          },
          emailTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
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
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": false,
            "placeHolderTextProperties": {
              "text": "Ihre Telefonnummer",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "alignment": "left",
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400.0,
            "minLines": 4,
            "maxLines": 5,
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
          },
          buttonProperties: {
            "width": 200.0,
            "height": 70.0,
            "border": {"radius": 4.0},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FFFFFFFF",
              "text": "NACHRICHT SENDEN"
            }
          });
      // When
      final result = PageBuilderContactFormPropertiesModel.fromDomain(model);
      // Then
      final deepEquality = DeepCollectionEquality();
      expect(
        deepEquality.equals(result.toMap(), expectedResult.toMap()),
        isTrue,
      );
      // expect(result, expectedResult);
    });
  });

  group("PagebuilderContactFormPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 200.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": true,
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
          },
          emailTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
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
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": false,
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "text": "Ihre Telefonnummer"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400.0,
            "minLines": 4,
            "maxLines": 5,
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
          },
          buttonProperties: {
            "width": 200.0,
            "height": 70.0,
            "border": {"radius": 4.0},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FFFFFFFF",
              "text": "NACHRICHT SENDEN"
            }
          });
      final properties2 = PageBuilderContactFormPropertiesModel(
          email: "test@test.de",
          nameTextFieldProperties: {
            "width": 200.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": true,
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
          },
          emailTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
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
          },
          phoneTextFieldProperties: {
            "width": 400.0,
            "minLines": 1,
            "maxLines": 1,
            "isRequired": false,
            "placeHolderTextProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "text": "Ihre Telefonnummer"
            },
            "textProperties": {
              "alignment": "left",
              "fontSize": 16.0,
              "fontFamily": "Roboto"
            }
          },
          messageTextFieldProperties: {
            "width": 400.0,
            "minLines": 4,
            "maxLines": 5,
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
          },
          buttonProperties: {
            "width": 200.0,
            "height": 70.0,
            "border": {"radius": 4.0},
            "backgroundPaint": {"color": "FF333A56"},
            "textProperties": {
              "alignment": "center",
              "fontSize": 16.0,
              "fontFamily": "Roboto",
              "color": "FFFFFFFF",
              "text": "NACHRICHT SENDEN"
            }
          });
      // Then
      expect(properties1, properties2);
    });
  });
}
