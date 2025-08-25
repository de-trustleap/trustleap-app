import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/application/feedback/admin_feedback/admin_feedback_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminFeedbackListTile extends StatelessWidget {
  final FeedbackItem feedbackItem;
  const AdminFeedbackListTile({super.key, required this.feedbackItem});

  void _showFullSizeImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteAlert(AppLocalizations localizations, BuildContext context,
      CustomNavigatorBase navigator) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: localizations.admin_feedback_delete_title,
              message: localizations.admin_feedback_delete_message,
              actionButtonTitle: localizations.admin_feedback_delete_button,
              cancelButtonTitle: localizations.admin_feedback_cancel_button,
              actionButtonAction: () {
                Modular.get<AdminFeedbackCubit>()
                    .deleteFeedback(feedbackItem.id.value);
                navigator.pop();
              },
              cancelButtonAction: () => navigator.pop());
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);

    return CollapsibleTile(
        backgroundColor: themeData.colorScheme.surface,
        showDivider: false,
        titleWidget:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(feedbackItem.title ?? "", style: themeData.textTheme.bodyLarge),
          IconButton(
            onPressed: () {
              showDeleteAlert(localizations, context, navigator);
            },
            icon: const Icon(Icons.delete),
            iconSize: 24,
            color: themeData.colorScheme.secondary,
          ),
        ]),
        children: [
          Text(localizations.admin_feedback_type_label,
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(feedbackItem.type?.name ?? "",
              style: themeData.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text(localizations.admin_feedback_description_label,
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(feedbackItem.description ?? "",
              style: themeData.textTheme.bodyMedium),
          if (feedbackItem.downloadImageUrls != null &&
              feedbackItem.downloadImageUrls!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(localizations.admin_feedback_images_label,
                style: themeData.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: feedbackItem.downloadImageUrls!.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            _showFullSizeImage(
                              context,
                              feedbackItem.downloadImageUrls![index],
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: themeData.colorScheme.outline,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: feedbackItem.thumbnailDownloadURLs !=
                                            null &&
                                        feedbackItem
                                                .thumbnailDownloadURLs!.length >
                                            index
                                    ? feedbackItem.thumbnailDownloadURLs![index]
                                    : feedbackItem.downloadImageUrls![index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: themeData.colorScheme.surface,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: themeData.colorScheme.errorContainer,
                                  child: Icon(
                                    Icons.error,
                                    color: themeData.colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
          if (feedbackItem.email != null && feedbackItem.email != "") ...[
            const SizedBox(height: 12),
            Text(localizations.admin_feedback_sender_label,
                style: themeData.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(feedbackItem.email ?? "",
                style: themeData.textTheme.bodyMedium)
          ]
        ]);
  }
}
