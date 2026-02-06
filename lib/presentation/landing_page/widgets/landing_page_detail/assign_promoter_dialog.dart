import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AssignPromoterDialog extends StatefulWidget {
  final LandingPage landingPage;
  final List<Promoter> currentlyAssigned;
  final VoidCallback onAssigned;

  const AssignPromoterDialog({
    super.key,
    required this.landingPage,
    required this.currentlyAssigned,
    required this.onAssigned,
  });

  @override
  State<AssignPromoterDialog> createState() => _AssignPromoterDialogState();
}

class _AssignPromoterDialogState extends State<AssignPromoterDialog> {
  final Map<String, bool> _selectedPromoters = {};
  final Map<String, bool> _initialSelection = {};
  bool _isSaving = false;
  bool _isLoading = true;
  List<Promoter> _allPromoters = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    for (final promoter in widget.currentlyAssigned) {
      _selectedPromoters[promoter.id.value] = true;
      _initialSelection[promoter.id.value] = true;
    }
    _loadAllPromoters();
  }

  void _loadAllPromoters() {
    final userState = Modular.get<UserObserverCubit>().state;
    if (userState is UserObserverSuccess) {
      Modular.get<LandingPageCubit>().getAllPromotersForUser(userState.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final landingPageCubit = Modular.get<LandingPageCubit>();

    return BlocListener<LandingPageCubit, LandingPageState>(
      bloc: landingPageCubit,
      listener: (context, state) {
        if (state is GetAllPromotersSuccessState) {
          setState(() {
            _allPromoters = state.promoters;
            _isLoading = false;
            _errorMessage = null;
          });
        } else if (state is GetAllPromotersFailureState) {
          setState(() {
            _isLoading = false;
            _errorMessage = localization.landing_page_detail_promoters_error_title;
          });
        } else if (state is GetAllPromotersLoadingState) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxWidth: responsiveValue.isMobile ? double.infinity : 600,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  localization.landing_page_detail_assign_promoter_title,
                  style: themeData.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _isSaving ? null : () => navigator.pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildPromoterList(themeData, localization),
            ),
            const SizedBox(height: 16),
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
                    title: localization.cancel_buttontitle,
                    width: responsiveValue.isMobile ? double.infinity : 150,
                    disabled: _isSaving,
                    onTap: () => navigator.pop(),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: PrimaryButton(
                    title: localization.changes_save_button_title,
                    width: responsiveValue.isMobile ? double.infinity : 200,
                    disabled: _allPromoters.isEmpty,
                    isLoading: _isSaving,
                    onTap: () => _saveAssignments(_allPromoters),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoterList(
    ThemeData themeData,
    AppLocalizations localization,
  ) {
    if (_isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: themeData.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_allPromoters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              color: themeData.colorScheme.secondary,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              localization.landing_page_detail_no_promoters_available,
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _allPromoters.length,
      itemBuilder: (context, index) {
        final promoter = _allPromoters[index];
        final isSelected = _selectedPromoters[promoter.id.value] ?? false;
        return CheckboxListTile(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              _selectedPromoters[promoter.id.value] = value ?? false;
            });
          },
          title: Text(
            '${promoter.firstName ?? ''} ${promoter.lastName ?? ''}'.trim(),
          ),
          subtitle: Text(promoter.email ?? ''),
          secondary: StatusBadge(
            isPositive: promoter.registered == true,
            label: promoter.registered == true
                ? localization.promoter_overview_registration_badge_registered
                : localization.promoter_overview_registration_badge_unregistered,
          ),
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }

  void _saveAssignments(List<Promoter> allPromoters) async {
    setState(() {
      _isSaving = true;
    });

    final navigator = CustomNavigator.of(context);
    final promoterCubit = Modular.get<PromoterCubit>();
    final landingPageId = widget.landingPage.id.value;
    final localization = AppLocalizations.of(context);

    final changedPromoters = <Promoter>[];
    for (final promoter in allPromoters) {
      final wasSelected = _initialSelection[promoter.id.value] ?? false;
      final isNowSelected = _selectedPromoters[promoter.id.value] ?? false;

      if (wasSelected != isNowSelected) {
        changedPromoters.add(promoter);
      }
    }

    if (changedPromoters.isEmpty) {
      navigator.pop();
      return;
    }

    int successCount = 0;
    int totalChanges = changedPromoters.length;

    for (final promoter in changedPromoters) {
      final isNowSelected = _selectedPromoters[promoter.id.value] ?? false;
      final currentLandingPageIds =
          List<String>.from(promoter.landingPageIDs ?? []);

      List<String> updatedLandingPageIds;
      if (isNowSelected) {
        if (!currentLandingPageIds.contains(landingPageId)) {
          updatedLandingPageIds = [...currentLandingPageIds, landingPageId];
        } else {
          updatedLandingPageIds = currentLandingPageIds;
        }
      } else {
        updatedLandingPageIds =
            currentLandingPageIds.where((id) => id != landingPageId).toList();
      }

      promoterCubit.editPromoter(
        promoter.registered ?? false,
        updatedLandingPageIds,
        promoter.id.value,
      );

      await for (final state in promoterCubit.stream) {
        if (state is PromoterEditSuccessState) {
          successCount++;
          break;
        } else if (state is PromoterEditFailureState) {
          break;
        }
      }
    }

    if (mounted) {
      navigator.pop();
      widget.onAssigned();

      if (successCount == totalChanges) {
        CustomSnackBar.of(context).showCustomSnackBar(
          localization.landing_page_detail_promoters_updated_success,
        );
      } else {
        CustomSnackBar.of(context).showCustomSnackBar(
          localization.landing_page_detail_promoters_updated_partial,
          SnackBarType.failure,
        );
      }
    }
  }
}
