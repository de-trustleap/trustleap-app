import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:flutter/material.dart';

class RecommendationManagerNotesTextfield extends StatefulWidget {
  final String initialText;
  final bool isEditing;
  final Function(String) onSave;
  const RecommendationManagerNotesTextfield(
      {super.key,
      required this.initialText,
      required this.isEditing,
      required this.onSave});

  @override
  State<RecommendationManagerNotesTextfield> createState() =>
      _RecommendationManagerNotesTextfieldState();
}

class _RecommendationManagerNotesTextfieldState
    extends State<RecommendationManagerNotesTextfield> {
  late String _text;
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _text = widget.initialText;
    _controller.text = _text;
    if (widget.isEditing) {
      _isEditing = true;
    }
  }

  @override
  void didUpdateWidget(
      covariant RecommendationManagerNotesTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEditing) {
      _isEditing = true;
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _controller.text = _text;
      }
    });
  }

  void _save() {
    setState(() {
      _text = _controller.text;
      _isEditing = false;
    });
    widget.onSave(_text);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(children: [
      _isEditing
          ? Expanded(
              child: FormTextfield(
                  controller: _controller,
                  disabled: false,
                  placeholder: "Hier Notizen eintragen...",
                  minLines: 2,
                  maxLines: 10,
                  desktopStyle: themeData.textTheme.bodySmall,
                  keyboardType: TextInputType.multiline))
          : Expanded(
              child: Text(_text,
                  style: themeData.textTheme.bodyMedium, softWrap: true)),
      const SizedBox(width: 8),
      IconButton(
          onPressed: _isEditing ? _save : _toggleEdit,
          tooltip: _isEditing ? "Notizen speichern" : "Notizen bearbeiten",
          icon: Icon(_isEditing ? Icons.save : Icons.edit,
              size: 24, color: themeData.colorScheme.secondary))
    ]);
  }
}
