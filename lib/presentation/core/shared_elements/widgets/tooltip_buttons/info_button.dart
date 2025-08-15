import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/tooltip_buttons/tooltip_base.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final String text;
  final double tooltipOffset;

  const InfoButton({
    super.key,
    required this.text,
    this.tooltipOffset = 30,
  });

  @override
  Widget build(BuildContext context) {
    return TooltipBase(
      text: text,
      showButton: false,
      tooltipOffset: tooltipOffset,
      child: Icon(
        Icons.info_outline,
        color: Theme.of(context).colorScheme.secondary,
        size: 24,
      ),
    );
  }
}
