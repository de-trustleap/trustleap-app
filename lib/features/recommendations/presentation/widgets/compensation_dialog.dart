import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/core/remote_config/app_remote_config_cubit.dart';
import 'package:finanzbegleiter/core/remote_config/app_remote_config_state.dart';
import 'package:finanzbegleiter/features/tremendous/application/tremendous_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/widgets/compensation_voucher_form.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_funding_source.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_order_request.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_product.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum CompensationOption { voucher, manual, skip }

class CompensationDialog extends StatefulWidget {
  final UserRecommendation recommendation;
  final CompensationOption initialOption;

  const CompensationDialog({
    super.key,
    required this.recommendation,
    this.initialOption = CompensationOption.skip,
  });

  @override
  State<CompensationDialog> createState() => _CompensationDialogState();
}

class _CompensationDialogState extends State<CompensationDialog> {
  late CompensationOption _selected;
  bool _isLoading = false;
  String? _errorMessage;

  TremendousProduct? _selectedProduct;
  TremendousFundingSource? _selectedFundingSource;
  late final TextEditingController _amountController;

  RecommendationCompensation? _getCompensation() {
    final reco = widget.recommendation.recommendation;
    return reco is PersonalizedRecommendationItem ? reco.compensation : null;
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    final tremendousEnabled = Modular.get<AppRemoteConfigCubit>().state.tremendousEnabled;
    final hasPriorFailure = widget.initialOption == CompensationOption.skip &&
        _getCompensation()?.status == RecommendationCompensationStatus.voucherFailed;
    _selected = hasPriorFailure && tremendousEnabled ? CompensationOption.voucher : widget.initialOption;
    if (_selected == CompensationOption.voucher && tremendousEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadCatalogIfNeeded());
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _loadCatalogIfNeeded() {
    final cubit = Modular.get<TremendousCubit>();
    final state = cubit.state;
    if (state is TremendousCatalogSuccessState) return;
    if (state is TremendousConnectedState) {
      cubit.loadCatalog();
    } else if (state is TremendousInitial ||
        state is TremendousNotConnectedState ||
        state is TremendousDisconnectedState) {
      cubit.startObservingConnectionStatus();
    }
  }

  void _onOptionChanged(CompensationOption? option) {
    if (_isLoading || option == null) return;
    if (option == CompensationOption.voucher) {
      _loadCatalogIfNeeded();
    }
    setState(() {
      _selected = option;
      _errorMessage = null;
    });
  }

  void _confirm(BuildContext context, RecommendationManagerTileCubit cubit) {
    if (_selected == CompensationOption.voucher) {
      _confirmVoucher(context, cubit);
      return;
    }
    final status = _selected == CompensationOption.manual
        ? RecommendationCompensationStatus.manualIssued
        : RecommendationCompensationStatus.skipped;
    cubit.setCompensation(widget.recommendation, status);
  }

  void _confirmVoucher(
      BuildContext context, RecommendationManagerTileCubit cubit) {
    final localization = AppLocalizations.of(context);
    final product = _selectedProduct;
    final source = _selectedFundingSource;
    final amount = int.tryParse(_amountController.text.trim());

    if (product == null) {
      setState(() => _errorMessage =
          localization.compensation_dialog_voucher_product_required);
      return;
    }
    if (source == null) {
      setState(() => _errorMessage =
          localization.compensation_dialog_voucher_funding_source_required);
      return;
    }
    final productMin = product.effectiveMin;
    final productMax = product.effectiveMax;

    if (amount == null || amount < productMin) {
      setState(() => _errorMessage =
          localization.compensation_dialog_voucher_amount_min(productMin));
      return;
    }
    if (amount > productMax) {
      setState(() => _errorMessage =
          localization.compensation_dialog_voucher_amount_max(productMax));
      return;
    }

    cubit.setCompensationVoucher(
      widget.recommendation,
      TremendousOrderRequest(
        productID: product.id,
        fundingSourceID: source.id,
        amount: amount.toDouble(),
        currency: source.currencyCode ?? 'EUR',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final navigator = CustomNavigator.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final cubit = Modular.get<RecommendationManagerTileCubit>();
    final tremendousCubit = Modular.get<TremendousCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<RecommendationManagerTileCubit,
            RecommendationManagerTileState>(
          bloc: cubit,
          listener: (context, state) {
            if (state is RecommendationCompensationLoadingState) {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
            } else if (state is RecommendationCompensationSuccessState) {
              navigator.pop();
            } else if (state is RecommendationCompensationFailureState) {
              setState(() {
                _isLoading = false;
                _errorMessage = DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization);
              });
            }
          },
        ),
        BlocListener<TremendousCubit, TremendousState>(
          bloc: tremendousCubit,
          listener: (context, state) {
            if (state is TremendousConnectedState &&
                _selected == CompensationOption.voucher) {
              tremendousCubit.loadCatalog();
            } else if (state is TremendousOAuthReadyState) {
              CustomNavigator.of(context).openURLInNewTab(state.authUrl);
            }
          },
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxWidth: responsiveValue.isMobile ? double.infinity : 540,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    localization.compensation_dialog_title,
                    style: themeData.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _isLoading ? null : () => navigator.pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              localization.compensation_dialog_subtitle,
              style: themeData.textTheme.bodyMedium?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AppRemoteConfigCubit, AppRemoteConfigState>(
              bloc: Modular.get<AppRemoteConfigCubit>(),
              builder: (context, configState) {
                return RadioGroup<CompensationOption>(
                  groupValue: _selected,
                  onChanged: _onOptionChanged,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (configState.tremendousEnabled) ...[
                        _buildOption(
                          context,
                          label: localization.compensation_dialog_voucher_option,
                          value: CompensationOption.voucher,
                        ),
                        if (_selected == CompensationOption.voucher)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: CompensationVoucherForm(
                              isLoading: _isLoading,
                              selectedProduct: _selectedProduct,
                              selectedFundingSource: _selectedFundingSource,
                              amountController: _amountController,
                              onProductChanged: (p) => setState(() {
                                _selectedProduct = p;
                                _errorMessage = null;
                              }),
                              onFundingSourceChanged: (s) => setState(() {
                                _selectedFundingSource = s;
                                _errorMessage = null;
                              }),
                              onConnectPressed: () =>
                                  Modular.get<TremendousCubit>().connect(),
                            ),
                          ),
                      ],
                      _buildOption(
                        context,
                        label: localization.compensation_dialog_manual_option,
                        value: CompensationOption.manual,
                      ),
                      _buildOption(
                        context,
                        label: localization.compensation_dialog_skip_option,
                        value: CompensationOption.skip,
                      ),
                    ],
                  ),
                );
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              FormErrorView(
                message: _errorMessage!,
                autoScroll: false,
              ),
            ],
            const SizedBox(height: 24),
            ResponsiveRowColumn(
              layout: responsiveValue.isMobile
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.stretch,
              columnSpacing: 12,
              rowSpacing: 12,
              children: [
                ResponsiveRowColumnItem(
                  child: SecondaryButton(
                    title: localization.compensation_dialog_cancel_button,
                    width: responsiveValue.isMobile ? double.infinity : 150,
                    disabled: _isLoading,
                    onTap: () => navigator.pop(),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: PrimaryButton(
                    title: localization.compensation_dialog_action_button,
                    width: responsiveValue.isMobile ? double.infinity : 150,
                    disabled: _isLoading,
                    isLoading: _isLoading,
                    onTap: () => _confirm(context, cubit),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required CompensationOption value,
  }) {
    final themeData = Theme.of(context);
    return RadioListTile<CompensationOption>(
      title: SelectableText(label, style: themeData.textTheme.bodyMedium),
      value: value,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
