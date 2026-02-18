import 'dart:async';

import 'package:finanzbegleiter/features/recommendations/application/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_overlay.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_confirmation_dialog.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_form_helper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_confirmation_dialog_error.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_sender.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web/web.dart' as web;

class RecommendationPreview extends StatefulWidget {
  final String userID;
  final List<RecommendationItem> leads;
  final Function(RecommendationItem) onSaveSuccess;
  final Function(RecommendationItem)? onDelete;
  final bool disabled;

  const RecommendationPreview({
    super.key,
    required this.userID,
    required this.leads,
    required this.onSaveSuccess,
    this.onDelete,
    this.disabled = false,
  });

  @override
  State<RecommendationPreview> createState() => _RecommendationPreviewState();
}

class _RecommendationPreviewState extends State<RecommendationPreview>
    with TickerProviderStateMixin {
  TabController? tabController;
  final Map<String, TextEditingController> _textControllers = {};
  StreamSubscription? _visibilitySubscription;
  bool showMissingLinkError = false;
  bool isAlertVisible = false;
  final RecommendationSender _sender = RecommendationSender();
  final RecommendationFormHelper _helper = RecommendationFormHelper();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    for (final lead in widget.leads) {
      final text = _helper.parseTemplate(lead, lead.promotionTemplate ?? "");
      _textControllers[lead.id] = TextEditingController(text: text);
    }

    _initTabController();
  }

  void _initTabController() {
    if (widget.leads.length > 1) {
      tabController = TabController(
        length: widget.leads.length,
        vsync: this,
      );
      tabController!.addListener(() {
        if (!tabController!.indexIsChanging) {
          setState(() {
            _selectedIndex = tabController!.index;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant RecommendationPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldIds = oldWidget.leads.map((l) => l.id).toSet();
    final newIds = widget.leads.map((l) => l.id).toSet();

    final removedIds = oldIds.difference(newIds);
    for (final id in removedIds) {
      _textControllers[id]?.dispose();
      _textControllers.remove(id);
    }

    for (final lead in widget.leads) {
      if (!_textControllers.containsKey(lead.id)) {
        final text = _helper.parseTemplate(lead, lead.promotionTemplate ?? "");
        _textControllers[lead.id] = TextEditingController(text: text);
      }
    }

    if (widget.leads.length > 1) {
      if (tabController == null ||
          tabController!.length != widget.leads.length) {
        tabController?.dispose();
        tabController = TabController(
          length: widget.leads.length,
          vsync: this,
        );
        tabController!.addListener(() {
          if (!tabController!.indexIsChanging) {
            setState(() {
              _selectedIndex = tabController!.index;
            });
          }
        });
      }
    } else {
      tabController?.dispose();
      tabController = null;
      _selectedIndex = 0;
    }

    if (_selectedIndex >= widget.leads.length) {
      _selectedIndex = widget.leads.isEmpty ? 0 : widget.leads.length - 1;
      if (tabController != null && widget.leads.isNotEmpty) {
        tabController!.index = _selectedIndex;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    tabController?.dispose();
    _visibilitySubscription?.cancel();
    super.dispose();
  }


  Future<void> _sendMessage(
      RecommendationItem recommendation, String message) async {
    if (!message.contains("[LINK]")) {
      setState(() {
        showMissingLinkError = true;
      });
      return;
    }
    setState(() {
      showMissingLinkError = false;
    });

    await _sender.sendViaWhatsApp(
      context: context,
      recommendation: recommendation,
      message: message,
      onWebOpen: () => _startComeBackToPageListener(recommendation),
    );
  }

  Future<void> _sendEmail(
      RecommendationItem recommendation, String message) async {
    if (!message.contains("[LINK]")) {
      setState(() {
        showMissingLinkError = true;
      });
      return;
    }
    setState(() {
      showMissingLinkError = false;
    });

    await _sender.sendViaEmail(
      context: context,
      recommendation: recommendation,
      message: message,
      onWebOpen: () => _startComeBackToPageListener(recommendation),
    );
  }

  void _startComeBackToPageListener(RecommendationItem recommendation) {
    _visibilitySubscription?.cancel();
    _visibilitySubscription = web.document.onVisibilityChange.listen((event) {
      if (!web.document.hidden && mounted && !isAlertVisible) {
        isAlertVisible = true;
        showDialog(
            context: context,
            builder: (_) {
              return RecommendationConfirmationDialog(
                  recommendationReceiverName: recommendation.displayName,
                  cancelAction: () {
                    isAlertVisible = false;
                    CustomNavigator.of(context).pop();
                  },
                  action: () =>
                      _onRecommendationSentSuccessful(recommendation));
            });
      }
    });
  }

  void _onRecommendationSentSuccessful(RecommendationItem recommendation) {
    Modular.get<RecommendationsAlertCubit>()
        .saveRecommendation(recommendation, widget.userID);
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "?";
    final parts = name.trim().split(" ");
    if (parts.length >= 2) {
      return "${parts.first[0]}${parts.last[0]}".toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = CustomNavigator.of(context);
    final recoCubit = Modular.get<RecommendationsAlertCubit>();
    final responsiveValue = ResponsiveHelper.of(context);

    return BlocListener<RecommendationsAlertCubit, RecommendationsAlertState>(
      bloc: recoCubit,
      listener: (context, state) {
        if (state is RecommendationSaveLoadingState) {
          if (isAlertVisible) {
            navigator.pop();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) {
                  final localization = AppLocalizations.of(dialogContext);
                  return LoadingOverlay(
                    title: localization.save_recommendation_loading_title,
                    subtitle: localization.save_recommendation_loading_subtitle,
                  );
                });
          }
        } else if (state is RecommendationSaveFailureState) {
          if (isAlertVisible) {
            navigator.pop();
            showDialog(
                context: context,
                builder: (_) {
                  return RecommendationConfirmationDialogError(
                      failure: state.failure,
                      recommendationReceiverName: state.recommendation.displayName,
                      cancelAction: () {
                        isAlertVisible = false;
                        navigator.pop();
                      },
                      action: () => _onRecommendationSentSuccessful(
                          state.recommendation));
                });
          }
        } else if (state is RecommendationSaveSuccessState) {
          if (isAlertVisible) {
            isAlertVisible = false;
            navigator.pop();
            widget.onSaveSuccess(state.recommendation);
          }
        }
      },
      child: _buildContent(responsiveValue),
    );
  }

  Widget _buildContent(ResponsiveBreakpointsData responsiveValue) {
    if (widget.leads.isEmpty) return const SizedBox();

    final lead = widget.leads.length == 1
        ? widget.leads.first
        : widget.leads[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.leads.length > 1) ...[
          TabBar(
            controller: tabController,
            tabs: widget.leads
                .map((lead) => CustomTab(
                      title: lead.displayName ?? "",
                      icon: Icons.person,
                      responsiveValue: responsiveValue,
                      totalTabs: widget.leads.length,
                    ))
                .toList(),
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorPadding: const EdgeInsets.only(bottom: 4),
          ),
          const SizedBox(height: 16),
        ],
        _buildLeadDetailCard(lead),
      ],
    );
  }

  Widget _buildLeadDetailCard(RecommendationItem lead) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final controller = _textControllers[lead.id];
    if (controller == null) return const SizedBox();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(lead.id),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeData.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: themeData.colorScheme.primary
                      .withValues(alpha: 0.15),
                  child: Text(
                    _getInitials(lead.displayName),
                    style: themeData.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeData.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.displayName ?? "",
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        localization.recommendation_customer_subtitle,
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    onPressed: () => widget.onDelete!(lead),
                    tooltip: localization.recommendation_manager_delete_alert_title,
                    icon: Icon(
                      Icons.delete_outline,
                      color: themeData.colorScheme.secondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.recommendation_promoter_label,
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        lead.promoterName ?? "",
                        style: themeData.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.recommendation_landingpage_label,
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        lead.reason ?? "",
                        style: themeData.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RecommendationTextField(
              controller: controller,
              leadName: lead.displayName ?? "",
              showError: showMissingLinkError,
              disabled: widget.disabled,
              onSendPressed: () {
                _sendMessage(lead, controller.text);
              },
              onEmailSendPressed: () {
                _sendEmail(lead, controller.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
