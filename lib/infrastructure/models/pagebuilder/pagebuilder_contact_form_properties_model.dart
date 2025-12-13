// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_textfield_properties_model.dart';

class PageBuilderContactFormPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? email;
  final Map<String, dynamic>? nameTextFieldProperties;
  final Map<String, dynamic>? emailTextFieldProperties;
  final Map<String, dynamic>? phoneTextFieldProperties;
  final Map<String, dynamic>? messageTextFieldProperties;
  final Map<String, dynamic>? buttonProperties;

  const PageBuilderContactFormPropertiesModel({
    required this.email,
    required this.nameTextFieldProperties,
    required this.emailTextFieldProperties,
    required this.phoneTextFieldProperties,
    required this.messageTextFieldProperties,
    required this.buttonProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (email != null) map['email'] = email;
    if (nameTextFieldProperties != null) {
      map['nameTextFieldProperties'] = nameTextFieldProperties;
    }
    if (emailTextFieldProperties != null) {
      map['emailTextFieldProperties'] = emailTextFieldProperties;
    }
    if (phoneTextFieldProperties != null) {
      map['phoneTextFieldProperties'] = phoneTextFieldProperties;
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
      email: map['email'] != null ? map['email'] as String : null,
      nameTextFieldProperties: map['nameTextFieldProperties'] != null
          ? map['nameTextFieldProperties'] as Map<String, dynamic>
          : null,
      emailTextFieldProperties: map['emailTextFieldProperties'] != null
          ? map['emailTextFieldProperties'] as Map<String, dynamic>
          : null,
      phoneTextFieldProperties: map['phoneTextFieldProperties'] != null
          ? map['phoneTextFieldProperties'] as Map<String, dynamic>
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
    String? email,
    Map<String, dynamic>? nameTextFieldProperties,
    Map<String, dynamic>? emailTextFieldProperties,
    Map<String, dynamic>? phoneTextFieldProperties,
    Map<String, dynamic>? messageTextFieldProperties,
    Map<String, dynamic>? buttonProperties,
  }) {
    return PageBuilderContactFormPropertiesModel(
      email: email ?? this.email,
      nameTextFieldProperties:
          nameTextFieldProperties ?? this.nameTextFieldProperties,
      emailTextFieldProperties:
          emailTextFieldProperties ?? this.emailTextFieldProperties,
      phoneTextFieldProperties:
          phoneTextFieldProperties ?? this.phoneTextFieldProperties,
      messageTextFieldProperties:
          messageTextFieldProperties ?? this.messageTextFieldProperties,
      buttonProperties: buttonProperties ?? this.buttonProperties,
    );
  }

  PageBuilderContactFormProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PageBuilderContactFormProperties(
        email: email,
        nameTextFieldProperties: nameTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromMap(
                    nameTextFieldProperties!)
                .toDomain(globalStyles)
            : null,
        emailTextFieldProperties: emailTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromMap(
                    emailTextFieldProperties!)
                .toDomain(globalStyles)
            : null,
        phoneTextFieldProperties: phoneTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromMap(
                    phoneTextFieldProperties!)
                .toDomain(globalStyles)
            : null,
        messageTextFieldProperties: messageTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromMap(
                    messageTextFieldProperties!)
                .toDomain(globalStyles)
            : null,
        buttonProperties: buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromMap(buttonProperties!)
                .toDomain(globalStyles)
            : null);
  }

  factory PageBuilderContactFormPropertiesModel.fromDomain(
      PageBuilderContactFormProperties properties) {
    return PageBuilderContactFormPropertiesModel(
        email: properties.email,
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
        phoneTextFieldProperties: properties.phoneTextFieldProperties != null
            ? PageBuilderTextFieldPropertiesModel.fromDomain(
                    properties.phoneTextFieldProperties!)
                .toMap()
            : null,
        messageTextFieldProperties:
            properties.messageTextFieldProperties != null
                ? PageBuilderTextFieldPropertiesModel.fromDomain(
                        properties.messageTextFieldProperties!)
                    .toMap()
                : null,
        buttonProperties: properties.buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromDomain(properties.buttonProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props => [
        email,
        nameTextFieldProperties,
        emailTextFieldProperties,
        phoneTextFieldProperties,
        messageTextFieldProperties,
        buttonProperties
      ];
}
