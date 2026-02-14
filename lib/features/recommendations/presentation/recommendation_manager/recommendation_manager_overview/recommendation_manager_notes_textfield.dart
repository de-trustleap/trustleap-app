import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManagerNotesTextfield extends StatefulWidget {
  final UserRecommendation recommendation;
  final bool isEditing;
  final Function(String) onSave;
  const RecommendationManagerNotesTextfield(
      {super.key,
      required this.recommendation,
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
    _text = widget.recommendation.notes ?? "";
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

  Widget _buildLastEditedWidget(BuildContext context, ThemeData themeData, AppLocalizations localization) {
    final notesLastEdit = widget.recommendation.getLastEdit("notes");
    if (notesLastEdit != null) {
      final cubit = Modular.get<RecommendationManagerTileCubit>();
      final currentUserID = cubit.currentUser?.id.value ?? "";
      final isCurrentUser = notesLastEdit.editedBy == currentUserID;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (isCurrentUser)
            Text(
                localization.recommendation_manager_notes_last_edited_by_user(
                    RecommendationManagerHelper(localization: localization).getDateText(context, notesLastEdit.editedAt)
                ),
                style: themeData.textTheme.bodySmall!.copyWith(fontSize: 13))
          else
            FutureBuilder<String>(
              future: cubit.getUserDisplayName(notesLastEdit.editedBy),
              builder: (context, snapshot) {
                final userName = snapshot.data ?? "";
                if (userName.isNotEmpty) {
                  return Text(
                      localization.recommendation_manager_notes_last_edited_by_other(
                          userName,
                          RecommendationManagerHelper(localization: localization).getDateText(context, notesLastEdit.editedAt)
                      ),
                      style: themeData.textTheme.bodySmall!.copyWith(fontSize: 13));
                } else {
                  return Text(
                      "${localization.recommendation_manager_notes_last_updated} ${RecommendationManagerHelper(localization: localization).getDateText(context, notesLastEdit.editedAt)}",
                      style: themeData.textTheme.bodySmall!.copyWith(fontSize: 13));
                }
              },
            )
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _isEditing
            ? Expanded(
                child: FormTextfield(
                    controller: _controller,
                    disabled: false,
                    placeholder:
                        localization.recommendation_manager_notes_placeholder,
                    minLines: 2,
                    maxLines: 10,
                    desktopStyle: themeData.textTheme.bodySmall,
                    keyboardType: TextInputType.multiline))
            : Flexible(
                fit: FlexFit.loose,
                child: Text(_text,
                    style: themeData.textTheme.bodyMedium, softWrap: true),
              ),
        const SizedBox(width: 8),
        IconButton(
            onPressed: _isEditing ? _save : _toggleEdit,
            tooltip: _isEditing
                ? localization.recommendation_manager_notes_save_button_tooltip
                : localization.recommendation_manager_notes_edit_button_tooltip,
            icon: Icon(_isEditing ? Icons.save : Icons.edit,
                size: 24, color: themeData.colorScheme.secondary))
      ]),
      _buildLastEditedWidget(context, themeData, localization)
    ]);
  }
}
