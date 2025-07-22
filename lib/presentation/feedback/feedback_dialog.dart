import 'dart:typed_data';

import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/feedback/feedback_image_upload.dart';
import 'package:finanzbegleiter/presentation/feedback/feedback_validator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Uint8List> selectedImages = [];
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onImagesSelected(List<Uint8List> images) {
    setState(() {
      selectedImages = images;
    });
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      // TODO: Implement feedback submission logic
      // This would typically send the data to your backend
      print('Feedback Title: ${titleController.text}');
      print('Feedback Description: ${descriptionController.text}');
      print('Number of images: ${selectedImages.length}');

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
          CustomSnackBar.of(context).showCustomSnackBar(
            'Feedback erfolgreich gesendet!',
            SnackBarType.success,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = FeedbackValidator(localization: localization);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.all(responsiveValue.isMobile ? 16 : 24),
      content: Container(
        width:
            responsiveValue.isMobile ? responsiveValue.screenWidth * 0.9 : 600,
        constraints: BoxConstraints(
          maxHeight: responsiveValue.screenHeight * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Feedback geben', // TODO: Add to localization
                  style: themeData.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  tooltip: 'Schließen', // TODO: Add to localization
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormTextfield(
                        maxWidth: double.infinity,
                        controller: titleController,
                        disabled: isLoading,
                        placeholder:
                            'Titel eingeben...', // TODO: Add to localization
                        validator: validator.validateTitle,
                      ),
                      const SizedBox(height: 16),
                      FormTextfield(
                        maxWidth: double.infinity,
                        controller: descriptionController,
                        disabled: isLoading,
                        placeholder:
                            'Beschreibung eingeben...', // TODO: Add to localization
                        validator: validator.validateDescription,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bilder (optional, max. 3)', // TODO: Add to localization
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FeedbackImageUpload(
                        onImagesSelected: onImagesSelected,
                        maxImages: 3,
                        disabled: isLoading,
                      ),
                      const SizedBox(height: 24),
                      responsiveValue.largerThan(MOBILE)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    title:
                                        'Abbrechen', // TODO: Add to localization
                                    onTap: onCancel,
                                    disabled: isLoading,
                                    width: 200,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: PrimaryButton(
                                    title:
                                        'Senden', // TODO: Add to localization
                                    onTap: isLoading ? null : onSubmit,
                                    width: 200,
                                    isLoading: isLoading,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SecondaryButton(
                                  title:
                                      'Abbrechen', // TODO: Add to localization
                                  onTap: onCancel,
                                  disabled: isLoading,
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 12),
                                PrimaryButton(
                                  title: 'Senden', // TODO: Add to localization
                                  onTap: isLoading ? null : onSubmit,
                                  width: double.infinity,
                                  isLoading: isLoading,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
