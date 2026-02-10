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

class AssignLandingPageDialog extends StatefulWidget {
  final Promoter promoter;
  final List<LandingPage> currentlyAssigned;
  final VoidCallback onAssigned;

  const AssignLandingPageDialog({
    super.key,
    required this.promoter,
    required this.currentlyAssigned,
    required this.onAssigned,
  });

  @override
  State<AssignLandingPageDialog> createState() =>
      _AssignLandingPageDialogState();
}

class _AssignLandingPageDialogState extends State<AssignLandingPageDialog> {
  final Map<String, bool> _selectedLandingPages = {};
  bool _isSaving = false;
  bool _isLoading = true;
  List<LandingPage> _allLandingPages = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    for (final lp in widget.currentlyAssigned) {
      _selectedLandingPages[lp.id.value] = true;
    }
    _loadAllLandingPages();
  }

  void _loadAllLandingPages() {
    final userState = Modular.get<UserObserverCubit>().state;
    if (userState is UserObserverSuccess) {
      Modular.get<PromoterCubit>()
          .getPromotingLandingPages(userState.user.landingPageIDs ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final promoterCubit = Modular.get<PromoterCubit>();

    return BlocListener<PromoterCubit, PromoterState>(
      bloc: promoterCubit,
      listener: (context, state) {
        if (state is PromoterGetLandingPagesSuccessState) {
          setState(() {
            _allLandingPages = state.landingPages;
            _isLoading = false;
            _errorMessage = null;
          });
        } else if (state is PromoterGetLandingPagesFailureState) {
          setState(() {
            _isLoading = false;
            _errorMessage = localization.promoter_detail_error_loading;
          });
        } else if (state is PromoterEditSuccessState) {
          navigator.pop();
          widget.onAssigned();
          CustomSnackBar.of(context).showCustomSnackBar(
            localization.promoter_detail_assign_success,
          );
        } else if (state is PromoterEditFailureState) {
          setState(() {
            _isSaving = false;
          });
          CustomSnackBar.of(context).showCustomSnackBar(
            localization.promoter_detail_error_loading,
            SnackBarType.failure,
          );
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
                  localization.promoter_detail_assign_page,
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
            const SizedBox(height: 4),
            Text(
              localization.promoter_detail_assign_dialog_subtitle,
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildLandingPageList(themeData, localization),
            ),
            const SizedBox(height: 16),
            ResponsiveRowColumn(
              layout: responsiveValue.isMobile
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              columnCrossAxisAlignment: CrossAxisAlignment.stretch,
              columnSpacing: 12,
              rowSpacing: 12,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: SecondaryButton(
                    title: localization.cancel_buttontitle,
                    width: double.infinity,
                    disabled: _isSaving,
                    onTap: () => navigator.pop(),
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: PrimaryButton(
                    title: localization.changes_save_button_title,
                    width: double.infinity,
                    disabled: _allLandingPages.isEmpty,
                    isLoading: _isSaving,
                    onTap: _saveAssignments,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandingPageList(
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

    if (_allLandingPages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.web_outlined,
              color: themeData.colorScheme.secondary,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              localization.promoter_detail_no_landing_pages,
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
      itemCount: _allLandingPages.length,
      itemBuilder: (context, index) {
        final lp = _allLandingPages[index];
        final isSelected = _selectedLandingPages[lp.id.value] ?? false;
        return CheckboxListTile(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              _selectedLandingPages[lp.id.value] = value ?? false;
            });
          },
          title: Text(lp.name ?? ''),
          secondary: StatusBadge(
            isPositive: lp.isActive == true,
            label: lp.isActive == true
                ? localization.landing_page_detail_status_active
                : localization.landing_page_detail_status_inactive,
          ),
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }

  void _saveAssignments() {
    final selectedIds = _selectedLandingPages.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    setState(() {
      _isSaving = true;
    });

    Modular.get<PromoterCubit>().editPromoter(
      widget.promoter.registered ?? false,
      selectedIds,
      widget.promoter.id.value,
    );
  }
}
