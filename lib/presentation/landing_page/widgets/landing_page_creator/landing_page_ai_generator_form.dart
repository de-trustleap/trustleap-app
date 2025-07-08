import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_ai_generation.dart';
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
    // AI Data an Parent weitergeben
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

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gib ein paar Informationen zu deinem Unternehmen ein und lass die KI eine maßgeschneiderte Landing Page erstellen.",
              style: themeData.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Landing Page Typ Auswahl
            Text(
              "Art der Landing Page:",
              style: themeData.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                RadioListTile<LandingPageType>(
                  title: const Text('Business/Unternehmen'),
                  value: LandingPageType.business,
                  groupValue: _selectedType,
                  onChanged: widget.disabled
                      ? null
                      : (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                ),
                RadioListTile<LandingPageType>(
                  title: const Text('Finanzberater'),
                  value: LandingPageType.financialAdvisor,
                  groupValue: _selectedType,
                  onChanged: widget.disabled
                      ? null
                      : (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                ),
                RadioListTile<LandingPageType>(
                  title: const Text('Individuell'),
                  value: LandingPageType.custom,
                  groupValue: _selectedType,
                  onChanged: widget.disabled
                      ? null
                      : (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                ),
              ],
            ),
            const SizedBox(height: 24),
            FormTextfield(
              controller: _businessTypeController,
              placeholder: _selectedType == LandingPageType.financialAdvisor
                  ? "Spezialisierung"
                  : "Branche/Unternehmenstyp",
              disabled: widget.disabled,
            ),
            const SizedBox(height: 16),
            FormTextfield(
              controller: _customDescriptionController,
              placeholder: "Zusätzliche Informationen (optional)",
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
              "$_currentLength/$_maxLength Zeichen",
              style: themeData.textTheme.bodySmall!.copyWith(
                color: _currentLength > _maxLength
                    ? themeData.colorScheme.error
                    : themeData.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Beispiel: 'Unser Café liegt in der Altstadt, Familienbetrieb seit 1890, gemütliche Atmosphäre, warme Braun/Beige-Töne gewünscht'",
              style: themeData.textTheme.bodySmall!.copyWith(
                color: themeData.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
