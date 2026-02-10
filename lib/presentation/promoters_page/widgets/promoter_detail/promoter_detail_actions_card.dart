import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/subtle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

class PromoterDetailActionsCard extends StatelessWidget {
  final Promoter promoter;
  final VoidCallback onDeleted;

  const PromoterDetailActionsCard({
    super.key,
    required this.promoter,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final promoterCubit = Modular.get<PromoterCubit>();

    return BlocListener<PromoterCubit, PromoterState>(
      bloc: promoterCubit,
      listener: (context, state) {
        if (state is PromoterDeleteSuccessState) {
          CustomSnackBar.of(context).showCustomSnackBar(
            localization.promoter_overview_delete_promoter_success_snackbar,
          );
          onDeleted();
        } else if (state is PromoterDeleteFailureState) {
          CustomSnackBar.of(context).showCustomSnackBar(
            localization.promoter_overview_delete_promoter_failure_snackbar,
            SnackBarType.failure,
          );
        }
      },
      child: CardContainer(
        maxWidth: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.promoter_detail_contact_actions,
              style: themeData.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                if (promoter.email != null)
                  SubtleButton(
                    title: localization.promoter_detail_send_email,
                    icon: Icons.email_outlined,
                    width: 300,
                    onTap: () {
                      launchUrl(Uri.parse('mailto:${promoter.email}'));
                    },
                  ),
                SubtleButton(
                  title: localization.promoter_detail_delete_promoter,
                  icon: Icons.delete_outlined,
                  width: 300,
                  backgroundColor: themeData.colorScheme.error,
                  onTap: () => _showDeleteDialog(context),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final promoterCubit = Modular.get<PromoterCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        title: localization.promoter_overview_delete_promoter_alert_title,
        message:
            localization.promoter_overview_delete_promoter_alert_description,
        actionButtonTitle:
            localization.promoter_overview_delete_promoter_alert_delete_button,
        actionButtonAction: () {
          Navigator.of(dialogContext).pop();
          promoterCubit.deletePromoter(
            promoter.id.value,
            promoter.registered == true,
          );
        },
        cancelButtonTitle:
            localization.promoter_overview_delete_promoter_alert_cancel_button,
        cancelButtonAction: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}
