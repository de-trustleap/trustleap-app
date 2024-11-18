// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/raw_form_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextfield extends StatelessWidget {
  final double? maxWidth;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool disabled;
  final String placeholder;
  final bool? obscureText;
  final FocusNode? focusNode;
  final Function? onChanged;
  final Function? onFieldSubmitted;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? desktopStyle;
  final Key? accessibilityKey;
  final Function? onTap;

  const FormTextfield(
      {super.key,
      this.maxWidth,
      required this.controller,
      required this.disabled,
      required this.placeholder,
      this.onChanged,
      this.validator,
      this.focusNode,
      this.obscureText,
      this.onFieldSubmitted,
      this.keyboardType,
      this.prefixIcon,
      this.maxLines,
      this.minLines,
      this.inputFormatters,
      this.desktopStyle,
      this.accessibilityKey,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (maxWidth != null) {
      return SizedBox(
          width: maxWidth,
          child: RawFormTextField(
              controller: controller,
              disabled: disabled,
              placeholder: placeholder,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              focusNode: focusNode,
              validator: validator,
              keyboardType: keyboardType,
              obscureText: obscureText,
              prefixIcon: prefixIcon,
              minLines: minLines,
              maxLines: maxLines,
              inputFormatters: inputFormatters,
              desktopStyle: desktopStyle,
              key: accessibilityKey,
              onTap: onTap));
    } else {
      return RawFormTextField(
          controller: controller,
          disabled: disabled,
          placeholder: placeholder,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          prefixIcon: prefixIcon,
          minLines: minLines,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          desktopStyle: desktopStyle,
          key: accessibilityKey,
          onTap: onTap);
    }
  }
}
