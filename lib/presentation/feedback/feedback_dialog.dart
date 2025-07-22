import 'dart:typed_data';

import 'package:finanzbegleiter/application/feedback/feedback_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/feedback.dart' as entities;
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/feedback/feedback_image_upload.dart';
import 'package:finanzbegleiter/presentation/feedback/feedback_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
      final feedback = entities.Feedback(
        id: UniqueID(),
        title: titleController.text,
        description: descriptionController.text,
      );
      Modular.get<FeedbackCubit>().sendFeedback(feedback, selectedImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = FeedbackValidator(localization: localization);
    final cubit = Modular.get<FeedbackCubit>();

    return BlocConsumer<FeedbackCubit, FeedbackState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is SentFeedbackSuccessState) {
          Navigator.of(context).pop();
          CustomSnackBar.of(context).showCustomSnackBar(
            localization.feedback_success_message,
            SnackBarType.success,
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.all(responsiveValue.isMobile ? 16 : 24),
          content: Container(
            width: responsiveValue.isMobile
                ? responsiveValue.screenWidth * 0.9
                : 600,
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
                      localization.feedback_dialog_title,
                      style: themeData.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: onCancel,
                      icon: const Icon(Icons.close),
                      tooltip: localization.feedback_dialog_close,
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
                            disabled: state is SentFeedbackLoadingState,
                            placeholder:
                                localization.feedback_title_placeholder,
                            validator: validator.validateTitle,
                          ),
                          const SizedBox(height: 16),
                          FormTextfield(
                            maxWidth: double.infinity,
                            controller: descriptionController,
                            disabled: state is SentFeedbackLoadingState,
                            placeholder:
                                localization.feedback_description_placeholder,
                            validator: validator.validateDescription,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localization.feedback_images_label,
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FeedbackImageUpload(
                            onImagesSelected: onImagesSelected,
                            maxImages: 3,
                            disabled: state is SentFeedbackLoadingState,
                          ),
                          const SizedBox(height: 24),
                          responsiveValue.largerThan(MOBILE)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SecondaryButton(
                                        title:
                                            localization.feedback_cancel_button,
                                        onTap: onCancel,
                                        disabled:
                                            state is SentFeedbackLoadingState,
                                        width: 200,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: PrimaryButton(
                                        title: localization
                                            .feedback_send_dialog_button,
                                        onTap: state is SentFeedbackLoadingState
                                            ? null
                                            : onSubmit,
                                        width: 200,
                                        isLoading:
                                            state is SentFeedbackLoadingState,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SecondaryButton(
                                      title:
                                          localization.feedback_cancel_button,
                                      onTap: onCancel,
                                      disabled:
                                          state is SentFeedbackLoadingState,
                                      width: double.infinity,
                                    ),
                                    const SizedBox(height: 12),
                                    PrimaryButton(
                                      title: localization
                                          .feedback_send_dialog_button,
                                      onTap: state is SentFeedbackLoadingState
                                          ? null
                                          : onSubmit,
                                      width: double.infinity,
                                      isLoading:
                                          state is SentFeedbackLoadingState,
                                    ),
                                  ],
                                ),
                          if (state is SentFeedbackFailureState) ...[
                            const SizedBox(height: 20),
                            FormErrorView(
                                message:
                                    DatabaseFailureMapper.mapFailureMessage(
                                        state.failure, localization))
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
