import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_ai_generation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandingPageAIGenerationForm extends StatefulWidget {
  final bool disabled;
  final Function(PagebuilderAiGeneration) onAIDataChanged;

  const LandingPageAIGenerationForm({
    super.key,
    required this.disabled,
    required this.onAIDataChanged,
  });

  @override
  State<LandingPageAIGenerationForm> createState() =>
      _LandingPageAIGenerationFormState();
}

enum LandingPageType { business, financialAdvisor, custom }

class _LandingPageAIGenerationFormState
    extends State<LandingPageAIGenerationForm> {
  final _businessTypeController = TextEditingController();
  final _customDescriptionController = TextEditingController();
  LandingPageType _selectedType = LandingPageType.business;
  int _currentLength = 0;
  static const int _maxLength = 500;

  @override
  void initState() {
    super.initState();
    _businessTypeController.addListener(_onContentChanged);
    _customDescriptionController.addListener(_onContentChanged);
    _customDescriptionController.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    _businessTypeController.dispose();
    _customDescriptionController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _currentLength = _customDescriptionController.text.length;
    });
  }

  void _onContentChanged() {
    final aiData = PagebuilderAiGeneration(
      businessType: _businessTypeController.text.isEmpty
          ? null
          : _businessTypeController.text,
      customDescription: _customDescriptionController.text.isEmpty
          ? null
          : _customDescriptionController.text,
    );
    widget.onAIDataChanged(aiData);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return IgnorePointer(
      ignoring: widget.disabled,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.landingpage_creator_ai_form_title,
              style: themeData.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              localization.landingpage_creator_ai_form_radio_title,
              style: themeData.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RadioGroup<LandingPageType>(
              groupValue: _selectedType,
              onChanged: (LandingPageType? value) {
                if (!widget.disabled && value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
              child: Column(
                children: [
                  RadioListTile<LandingPageType>(
                    title: Text(
                        localization.landingpage_creator_ai_form_radio_business),
                    value: LandingPageType.business,
                  ),
                  RadioListTile<LandingPageType>(
                    title: Text(
                        localization.landingpage_creator_ai_form_radio_finance),
                    value: LandingPageType.financialAdvisor,
                  ),
                  RadioListTile<LandingPageType>(
                    title: Text(localization
                        .landingpage_creator_ai_form_radio_individual),
                    value: LandingPageType.custom,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FormTextfield(
              controller: _businessTypeController,
              placeholder: _selectedType == LandingPageType.financialAdvisor
                  ? localization.landingpage_creator_ai_form_finance_placeholder
                  : localization
                      .landingpage_creator_ai_form_business_placeholder,
              disabled: widget.disabled,
            ),
            const SizedBox(height: 16),
            FormTextfield(
              controller: _customDescriptionController,
              placeholder: localization
                  .landingpage_creator_ai_form_custom_description_placeholder,
              maxLines: 5,
              minLines: 3,
              keyboardType: TextInputType.multiline,
              disabled: widget.disabled,
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "$_currentLength/$_maxLength ${localization.landingpage_creator_ai_form_character_count}",
              style: themeData.textTheme.bodySmall!.copyWith(
                color: _currentLength > _maxLength
                    ? themeData.colorScheme.error
                    : themeData.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              localization.landingpage_creator_ai_form_example,
              style: themeData.textTheme.bodySmall!.copyWith(
                color: themeData.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
