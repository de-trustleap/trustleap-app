// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';

class RawFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool disabled;
  final String placeholder;
  final FocusNode? focusNode;
  final bool? obscureText;
  final Function? onChanged;
  final Function? onEditingComplete;
  final Function? onFieldSubmitted;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final int? minLines;
  final int? maxLines;
  final EdgeInsets? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? desktopStyle;
  final Function? onTap;

  const RawFormTextField(
      {super.key,
      required this.controller,
      required this.disabled,
      required this.placeholder,
      this.focusNode,
      this.obscureText,
      required this.onChanged,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.keyboardType,
      this.validator,
      this.prefixIcon,
      this.minLines,
      this.maxLines,
      this.contentPadding,
      this.inputFormatters,
      this.desktopStyle,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) {
        if (onChanged != null) {
          onChanged!();
        }
      },
      onEditingComplete: () =>
          onEditingComplete != null ? onEditingComplete!() : (),
      onFieldSubmitted: (_) =>
          onFieldSubmitted != null ? onFieldSubmitted!() : (),
      readOnly: disabled ? true : false,
      obscureText: obscureText != null ? obscureText! : false,
      validator: validator,
      focusNode: focusNode,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      style: responsiveValue.isMobile
          ? themeData.textTheme.bodySmall
          : desktopStyle,
      inputFormatters: inputFormatters,
      onTap: () => onTap != null ? onTap!() : (),
      decoration: InputDecoration(
          prefixIcon: prefixIcon != null ? Icon(prefixIcon!) : null,
          labelText: placeholder,
          hoverColor: Colors.transparent,
          filled: disabled ? true : false,
          fillColor: themeData.colorScheme.surface,
          contentPadding: contentPadding,
          counterText: ""),
    );
  }
}
