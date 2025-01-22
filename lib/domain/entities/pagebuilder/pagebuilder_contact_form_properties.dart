import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderContactFormProperties extends Equatable
    implements PageBuilderProperties {
  final String? email;
  final PageBuilderTextFieldProperties? nameTextFieldProperties;
  final PageBuilderTextFieldProperties? emailTextFieldProperties;
  final PageBuilderTextFieldProperties? messageTextFieldProperties;
  final PageBuilderButtonProperties? buttonProperties;

  const PageBuilderContactFormProperties({
    required this.email,
    required this.nameTextFieldProperties,
    required this.emailTextFieldProperties,
    required this.messageTextFieldProperties,
    required this.buttonProperties,
  });

  PageBuilderContactFormProperties copyWith(
      {String? email,
      PageBuilderTextFieldProperties? nameTextFieldProperties,
      PageBuilderTextFieldProperties? emailTextFieldProperties,
      PageBuilderTextFieldProperties? messageTextFieldProperties,
      PageBuilderButtonProperties? buttonProperties}) {
    return PageBuilderContactFormProperties(
      email: email ?? this.email,
      nameTextFieldProperties:
          nameTextFieldProperties ?? this.nameTextFieldProperties,
      emailTextFieldProperties:
          emailTextFieldProperties ?? this.emailTextFieldProperties,
      messageTextFieldProperties:
          messageTextFieldProperties ?? this.messageTextFieldProperties,
      buttonProperties: buttonProperties ?? this.buttonProperties,
    );
  }

  @override
  List<Object?> get props => [
        email,
        nameTextFieldProperties,
        emailTextFieldProperties,
        messageTextFieldProperties,
        buttonProperties
      ];
}
