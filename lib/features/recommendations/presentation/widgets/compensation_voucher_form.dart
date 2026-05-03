import "package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_dropdown.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/widgets/raw_form_textfield.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart";
import "package:finanzbegleiter/features/tremendous/application/tremendous_cubit.dart";
import "package:finanzbegleiter/features/tremendous/domain/tremendous_funding_source.dart";
import "package:finanzbegleiter/features/tremendous/domain/tremendous_product.dart";
import "package:finanzbegleiter/l10n/generated/app_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart";

class CompensationVoucherForm extends StatelessWidget {
  final bool isLoading;
  final TremendousProduct? selectedProduct;
  final TremendousFundingSource? selectedFundingSource;
  final TextEditingController amountController;
  final ValueChanged<TremendousProduct?> onProductChanged;
  final ValueChanged<TremendousFundingSource?> onFundingSourceChanged;
  final VoidCallback onConnectPressed;

  const CompensationVoucherForm({
    super.key,
    required this.isLoading,
    required this.selectedProduct,
    required this.selectedFundingSource,
    required this.amountController,
    required this.onProductChanged,
    required this.onFundingSourceChanged,
    required this.onConnectPressed,
  });

  static String _fundingSourceLabel(String method, AppLocalizations l10n) {
    switch (method) {
      case "balance":
        return l10n.tremendous_funding_source_balance;
      case "invoice":
        return l10n.tremendous_funding_source_invoice;
      case "credit_card":
        return l10n.tremendous_funding_source_credit_card;
      case "ach":
        return l10n.tremendous_funding_source_ach;
      case "sepa":
        return l10n.tremendous_funding_source_sepa;
      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tremendousCubit = Modular.get<TremendousCubit>();
    return BlocBuilder<TremendousCubit, TremendousState>(
      bloc: tremendousCubit,
      builder: (context, state) {
        if (state is TremendousNotConnectedState ||
            state is TremendousInitial ||
            state is TremendousDisconnectedState) {
          return _buildConnectSection(context);
        }
        if (state is TremendousCatalogSuccessState) {
          return _buildForm(context, state);
        }
        if (state is TremendousCatalogFailureState) {
          return _buildError(context, tremendousCubit);
        }
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildConnectSection(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            localization.compensation_dialog_voucher_connect_hint,
            style: themeData.textTheme.bodySmall
                ?.copyWith(color: themeData.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            title: localization.tremendous_connect_button,
            disabled: isLoading,
            width: 220,
            onTap: onConnectPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, TremendousCubit cubit) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            localization.compensation_dialog_voucher_catalog_error,
            style: themeData.textTheme.bodySmall
                ?.copyWith(color: themeData.colorScheme.error),
          ),
          const SizedBox(height: 8),
          SecondaryButton(
            title: localization.compensation_voucher_retry_button,
            disabled: isLoading,
            width: 160,
            onTap: cubit.loadCatalog,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, TremendousCatalogSuccessState state) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    final sourceItems = state.fundingSources
        .map((s) => CustomDropdownItem<TremendousFundingSource>(
              value: s,
              label: _fundingSourceLabel(s.method, localization),
            ))
        .toList();

    final productItems = state.products
        .map((p) => CustomDropdownItem<TremendousProduct>(
              value: p,
              label: p.name,
            ))
        .toList();

    final currency = selectedFundingSource?.currencyCode ?? "EUR";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        CustomDropdown<TremendousFundingSource>(
          value: selectedFundingSource,
          items: sourceItems,
          label: localization.compensation_dialog_voucher_funding_source_label,
          onChanged: isLoading ? null : onFundingSourceChanged,
        ),
        const SizedBox(height: 12),
        CustomDropdown<TremendousProduct>(
          value: selectedProduct,
          items: productItems,
          label: localization.compensation_dialog_voucher_product_label,
          onChanged: isLoading ? null : onProductChanged,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RawFormTextField(
                controller: amountController,
                disabled: isLoading,
                placeholder:
                    localization.compensation_dialog_voucher_amount_label,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: () {},
              ),
            ),
            const SizedBox(width: 12),
            SelectableText(
              currency,
              style: themeData.textTheme.bodyMedium,
            ),
          ],
        ),
        if (selectedProduct?.min != null || selectedProduct?.max != null) ...[
          const SizedBox(height: 4),
          _buildAmountHint(context, selectedProduct!),
        ],
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildAmountHint(BuildContext context, TremendousProduct product) {
    final themeData = Theme.of(context);
    final productMin = product.effectiveMin;
    final productMax = product.effectiveMax;
    final hint = "$productMin–$productMax €";
    return SelectableText(
      hint,
      style: themeData.textTheme.bodySmall
          ?.copyWith(color: themeData.colorScheme.onSurfaceVariant),
    );
  }
}
