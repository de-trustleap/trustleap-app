import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/tooltip_buttons/tooltip_base.dart';
import 'package:flutter/material.dart';

class TooltipIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? buttonText;
  final bool showButton;
  final VoidCallback? onPressed;
  final double tooltipOffset;

  const TooltipIcon({
    super.key,
    required this.icon,
    required this.text,
    this.buttonText,
    this.onPressed,
    this.showButton = true,
    this.tooltipOffset = 30,
  });

  @override
  Widget build(BuildContext context) {
    return TooltipBase(
      text: text,
      buttonText: buttonText,
      showButton: showButton,
      onPressed: onPressed,
      tooltipOffset: tooltipOffset,
      child: Icon(icon, color: Colors.red, size: 24),
    );
  }
}
