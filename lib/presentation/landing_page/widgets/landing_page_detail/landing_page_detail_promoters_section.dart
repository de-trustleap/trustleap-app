import 'package:finanzbegleiter/application/landingpages/landing_page_detail/landing_page_detail_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/promoter_stats.dart';
import 'package:finanzbegleiter/domain/statistics/promoter_statistics.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/subtle_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/assign_promoter_dialog.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_promoter_stats_card.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_promoter_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailPromotersSection extends StatefulWidget {
  final LandingPage landingPage;

  const LandingPageDetailPromotersSection({
    super.key,
    required this.landingPage,
  });

  @override
  State<LandingPageDetailPromotersSection> createState() =>
      _LandingPageDetailPromotersSectionState();
}

class _LandingPageDetailPromotersSectionState
    extends State<LandingPageDetailPromotersSection> {
  List<Promoter> _assignedPromoters = [];
  List<PromoterRecommendations>? _promoterRecommendations;
  PromoterStatistics? _statistics;
  bool _isLoading = true;
  String? _errorMessage;
  List<String>? _lastAssociatedUsersIDs;

  @override
  void initState() {
    super.initState();
    _lastAssociatedUsersIDs = widget.landingPage.associatedUsersIDs;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPromoters();
    });
  }

  void _updateStatistics() {
    if (_promoterRecommendations != null) {
      _statistics = PromoterStatistics(
        promoterRecommendations: _promoterRecommendations!,
        landingPageName: widget.landingPage.name,
      );
      _assignedPromoters = _statistics!.sortByConversions(_assignedPromoters);
    }
  }

  void _loadPromoters() {
    Modular.get<LandingPageDetailCubit>().getAssignedPromoters(
      widget.landingPage.associatedUsersIDs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final detailCubit = Modular.get<LandingPageDetailCubit>();
    final promoterCubit = Modular.get<PromoterCubit>();
    final landingPageObserverCubit = Modular.get<LandingPageObserverCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LandingPageObserverCubit, LandingPageObserverState>(
          bloc: landingPageObserverCubit,
          listener: (context, state) {
            if (state is LandingPageObserverSuccess) {
              final currentLandingPage = state.landingPages.firstWhere(
                (lp) => lp.id.value == widget.landingPage.id.value,
                orElse: () => widget.landingPage,
              );
              final newIds = currentLandingPage.associatedUsersIDs;
              if (newIds.toString() != _lastAssociatedUsersIDs.toString()) {
                _lastAssociatedUsersIDs = newIds;
                Modular.get<LandingPageDetailCubit>().getAssignedPromoters(newIds);
              }
            }
          },
        ),
        BlocListener<LandingPageDetailCubit, LandingPageDetailState>(
          bloc: detailCubit,
          listener: (context, state) {
            if (state is LandingPageDetailPromotersSuccess) {
              setState(() {
                _assignedPromoters = state.promoters;
                _isLoading = false;
                _errorMessage = null;
                _updateStatistics();
              });
            } else if (state is LandingPageDetailPromotersFailure) {
              setState(() {
                _isLoading = false;
                _errorMessage = DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization);
              });
            } else if (state is LandingPageDetailPromotersLoading) {
              setState(() => _isLoading = true);
            } else if (state is LandingPageDetailRecommendationsSuccess) {
              setState(() {
                _promoterRecommendations = state.promoterRecommendations;
                _updateStatistics();
              });
            }
          },
        ),
        BlocListener<PromoterCubit, PromoterState>(
          bloc: promoterCubit,
          listener: (context, state) {
            if (state is PromoterEditSuccessState) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.landing_page_detail_promoter_removed_success);
            } else if (state is PromoterEditFailureState) {
              CustomSnackBar.of(context).showCustomSnackBar(
                DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                SnackBarType.failure,
              );
            }
          },
        ),
      ],
      child: CardContainer(
        maxWidth: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(themeData, localization),
            if (_assignedPromoters.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildStats(themeData, localization),
            ],
            const SizedBox(height: 20),
            _buildPromotersList(themeData, localization),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData themeData, AppLocalizations localization) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                localization.landing_page_detail_assigned_promoters,
                style: themeData.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SelectableText(
                localization.landing_page_detail_assigned_promoters_subtitle,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SubtleButton(
          title: localization.landing_page_detail_assign_promoter,
          icon: Icons.person_add_outlined,
          onTap: () => _showAssignDialog(),
        ),
      ],
    );
  }

  Widget _buildStats(ThemeData themeData, AppLocalizations localization) {
    final total = _assignedPromoters.length;
    final registered =
        _assignedPromoters.where((p) => p.registered == true).length;
    final unregistered = total - registered;
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return ResponsiveRowColumn(
      layout: responsiveValue.isMobile
          ? ResponsiveRowColumnType.COLUMN
          : ResponsiveRowColumnType.ROW,
      rowSpacing: 12,
      columnSpacing: 8,
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: LandingPageDetailPromoterStatsCard(
            icon: Icons.groups_outlined,
            value: total.toString(),
            label: localization.landing_page_detail_total_promoters,
            color: themeData.colorScheme.primary,
          ),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: LandingPageDetailPromoterStatsCard(
            icon: Icons.verified_outlined,
            value: registered.toString(),
            label: localization.landing_page_detail_registered_promoters,
            color: themeData.colorScheme.primary,
          ),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: LandingPageDetailPromoterStatsCard(
            icon: Icons.pending_outlined,
            value: unregistered.toString(),
            label: localization.landing_page_detail_unregistered_promoters,
            color: themeData.colorScheme.error,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotersList(
      ThemeData themeData, AppLocalizations localization) {
    if (_isLoading) {
      return const Center(
          child:
              Padding(padding: EdgeInsets.all(24), child: LoadingIndicator()));
    }
    if (_errorMessage != null) {
      return ErrorView(
        title: localization.landing_page_detail_promoters_error_title,
        message: _errorMessage!,
        callback: _loadPromoters,
      );
    }
    if (_assignedPromoters.isEmpty) {
      return _buildEmptyState(themeData, localization);
    }
    final navigator = CustomNavigator.of(context);
    return Column(
      children: _assignedPromoters
          .map((p) => LandingPageDetailPromoterTile(
                promoter: p,
                stats: _statistics?.getStatsForPromoter(p.id.value) ??
                    const PromoterStats(shares: 0, conversions: 0),
                onRemove: () => _showRemoveDialog(p),
                onTap: () => navigator.navigate(
                    "${RoutePaths.homePath}${RoutePaths.promoterDetailPath}/${p.id.value}"),
              ))
          .toList(),
    );
  }

  Widget _buildEmptyState(ThemeData themeData, AppLocalizations localization) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.person_off_outlined,
                color: themeData.colorScheme.secondary, size: 48),
            const SizedBox(height: 12),
            Text(
              localization.landing_page_detail_no_promoters,
              style: TextStyle(color: themeData.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: AssignPromoterDialog(
          landingPage: widget.landingPage,
          currentlyAssigned: _assignedPromoters,
          onAssigned: _loadPromoters,
        ),
      ),
    );
  }

  void _showRemoveDialog(Promoter promoter) {
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final promoterName =
        '${promoter.firstName ?? ''} ${promoter.lastName ?? ''}'.trim();

    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        title: localization.landing_page_detail_remove_promoter_title,
        message: localization
            .landing_page_detail_remove_promoter_message(promoterName),
        actionButtonTitle: localization.landing_page_detail_remove_promoter_button,
        cancelButtonTitle: localization.cancel_buttontitle,
        actionButtonAction: () {
          navigator.pop();
          _removePromoter(promoter);
        },
        cancelButtonAction: () => navigator.pop(),
      ),
    );
  }

  void _removePromoter(Promoter promoter) {
    final cubit = Modular.get<PromoterCubit>();
    final updatedIds = (promoter.landingPageIDs ?? [])
        .where((id) => id != widget.landingPage.id.value)
        .toList();

    cubit.editPromoter(
        promoter.registered ?? false, updatedIds, promoter.id.value);
  }
}
