// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_textfield_properties_model.dart';

class PageBuilderContactFormPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final Map<String, dynamic>? nameTextFieldProperties;
  final Map<String, dynamic>? emailTextFieldProperties;
  final Map<String, dynamic>? messageTextFieldProperties;
  final Map<String, dynamic>? buttonProperties;

  const PageBuilderContactFormPropertiesModel({
    required this.nameTextFieldProperties,
    required this.emailTextFieldProperties,
    required this.messageTextFieldProperties,
    required this.buttonProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (nameTextFieldProperties != null) {
      map['nameTextFieldProperties'] = nameTextFieldProperties;
    }
    if (emailTextFieldProperties != null) {
      map['emailTextFieldProperties'] = emailTextFieldProperties;
    }
    if (messageTextFieldProperties != null) {
      map['messageTextFieldProperties'] = messageTextFieldProperties;
    }
    if (buttonProperties != null) map['buttonProperties'] = buttonProperties;
    return map;
  }

  factory PageBuilderContactFormPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PageBuilderContactFormPropertiesModel(
      nameTextFieldProperties: map['nameTextFieldProperties'] != null
          ? map['nameTextFieldProperties'] as Map<String, dynamic>
          : null,
      emailTextFieldProperties: map['emailTextFieldProperties'] != null
          ? map['emailTextFieldProperties'] as Map<String, dynamic>
          : null,
      messageTextFieldProperties: map['messageTextFieldProperties'] != null
          ? map['messageTextFieldProperties'] as Map<String, dynamic>
          : null,
      buttonProperties: map['buttonProperties'] != null
          ? map['buttonProperties'] as Map<String, dynamic>
          : null,
    );
  }

  PageBuilderContactFormPropertiesModel copyWith({
    Map<String, dynamic>? nameTextFieldProperties,
    Map<String, dynamic>? emailTextFieldProperties,
    Map<String, dynamic>? messageTextFieldProperties,
    Map<String, dynamic>? buttonProperties,
  }) {
    return PageBuilderContactFormPropertiesModel(
      nameTextFieldProperties:
          nameTextFieldProperties ?? this.nameTextFieldProperties,
      emailTextFieldProperties:
          emailTextFieldProperties ?? this.emailTextFieldProperties,
      messageTextFieldProperties:
          messageTextFieldProperties ?? this.messageTextFieldProperties,
      buttonProperties: buttonProperties ?? this.buttonProperties,
    );
  }

  PageBuilderContactFormProperties toDomain() {
    return PageBuilderContactFormProperties(
        nameTextFieldProperties: nameTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromMap(
                    nameTextFieldProperties!)
                .toDomain()
            : null,
        emailTextFieldProperties: emailTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromMap(
                    emailTextFieldProperties!)
                .toDomain()
            : null,
        messageTextFieldProperties: messageTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromMap(
                    messageTextFieldProperties!)
                .toDomain()
            : null,
        buttonProperties: buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromMap(buttonProperties!)
                .toDomain()
            : null);
  }

  factory PageBuilderContactFormPropertiesModel.fromDomain(
      PageBuilderContactFormProperties properties) {
    return PageBuilderContactFormPropertiesModel(
        nameTextFieldProperties: properties.nameTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromDomain(
                    properties.nameTextFieldProperties!)
                .toMap()
            : null,
        emailTextFieldProperties: properties.emailTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromDomain(
                    properties.emailTextFieldProperties!)
                .toMap()
            : null,
        messageTextFieldProperties:
            properties.messageTextFieldProperties != null
                ? PageBuilderTextFieldPropertiesModel.fromDomain(
                        properties.messageTextFieldProperties!)
                    .toMap()
                : null,
        buttonProperties: properties.buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromDomain(
                    properties.buttonProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props => [
        nameTextFieldProperties,
        emailTextFieldProperties,
        messageTextFieldProperties,
        buttonProperties
      ];
}
