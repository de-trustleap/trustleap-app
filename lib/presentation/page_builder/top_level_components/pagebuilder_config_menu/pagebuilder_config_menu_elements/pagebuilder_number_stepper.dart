import 'package:finanzbegleiter/core/helpers/textfield_decimal_number_formatter.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:flutter/material.dart';

class PagebuilderNumberStepper extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String placeholder;
  final Function(int) onSelected;

  const PagebuilderNumberStepper(
      {super.key,
      required this.initialValue,
      required this.minValue,
      required this.maxValue,
      required this.onSelected,
      this.placeholder = ""});

  @override
  State<PagebuilderNumberStepper> createState() =>
      _NumberInputWithArrowsState();
}

class _NumberInputWithArrowsState extends State<PagebuilderNumberStepper> {
  late TextEditingController _controller;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
  }

  void _increment() {
    if (_currentValue < widget.maxValue) {
      setState(() {
        _currentValue++;
        _controller.text = _currentValue.toString();
      });
      widget.onSelected(_currentValue);
    }
  }

  void _decrement() {
    if (_currentValue > widget.minValue) {
      setState(() {
        _currentValue--;
        _controller.text = _currentValue.toString();
      });
      widget.onSelected(_currentValue);
    }
  }

  void _onInputChanged() {
    final value = int.tryParse(_controller.text);
    if (value != null && value >= widget.minValue && value <= widget.maxValue) {
      setState(() {
        _currentValue = value;
      });
      widget.onSelected(_currentValue);
    } else {
      _controller.text = _currentValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 75,
          child: FormTextfield(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              DecimalNumberFormatter(maxIntegerDigits: 3, maxDecimalDigits: 0)
            ],
            disabled: false,
            placeholder: widget.placeholder,
            onChanged: _onInputChanged,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _increment,
              icon: const Icon(Icons.arrow_drop_up),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(0),
            ),
            IconButton(
              onPressed: _decrement,
              icon: const Icon(Icons.arrow_drop_down),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(0),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
