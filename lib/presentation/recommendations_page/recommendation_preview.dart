import 'dart:async';

import 'package:finanzbegleiter/application/recommendations/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_overlay.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_template_placeholder.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_confirmation_dialog.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_confirmation_dialog_error.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_sender.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web/web.dart' as web;

class RecommendationPreview extends StatefulWidget {
  final String userID;
  final List<RecommendationItem> leads;
  final Function(RecommendationItem) onSaveSuccess;
  final bool disabled;

  const RecommendationPreview(
      {super.key,
      required this.userID,
      required this.leads,
      required this.onSaveSuccess,
      this.disabled = false});

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

  @override
  void initState() {
    super.initState();

    for (final lead in widget.leads) {
      final text = parseTemplate(lead, lead.promotionTemplate ?? "");
      _textControllers[lead.id] = TextEditingController(text: text);
    }

    if (widget.leads.length > 1) {
      tabController = TabController(
        length: widget.leads.length,
        vsync: this,
      );
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
        final text = parseTemplate(lead, lead.promotionTemplate ?? "");
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
      }
    } else {
      tabController?.dispose();
      tabController = null;
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

  String parseTemplate(RecommendationItem lead, String template) {
    final serviceProviderLastName =
        (lead.serviceProviderName?.split(" "))?.skip(1).join(" ");
    final promoterLastName = (lead.promoterName?.split(" "))?.skip(1).join(" ");
    final replacements = {
      LandingPageTemplatePlaceholder.receiverName: lead.name,
      LandingPageTemplatePlaceholder.providerFirstName:
          lead.serviceProviderName?.split(" ").first,
      LandingPageTemplatePlaceholder.providerLastName: serviceProviderLastName,
      LandingPageTemplatePlaceholder.providerName:
          "${lead.serviceProviderName?.split(" ").first} $serviceProviderLastName",
      LandingPageTemplatePlaceholder.promoterFirstName:
          lead.promoterName?.split(" ").first,
      LandingPageTemplatePlaceholder.promoterLastName: promoterLastName,
      LandingPageTemplatePlaceholder.promoterName:
          "${lead.promoterName?.split(" ").first} $promoterLastName"
    };

    var result = template;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value ?? "");
    });
    result += "\n[LINK]";
    return result;
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
                  recommendationReceiverName: recommendation.name,
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

  @override
  Widget build(BuildContext context) {
    final navigator = CustomNavigator.of(context);
    final recoCubit = Modular.get<RecommendationsAlertCubit>();
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
                      recommendationReceiverName: state.recommendation.name,
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
      child: widget.leads.length <= 1
          ? _buildSingleRecommendationWidget()
          : _buildMultipleRecommendationsWidget(),
    );
  }

  Widget _buildSingleRecommendationWidget() {
    final lead = widget.leads.isNotEmpty ? widget.leads.first : null;
    if (lead == null) {
      return const SizedBox();
    }
    final controller = _textControllers[lead.id]!;
    return RecommendationTextField(
      controller: controller,
      leadName: lead.name ?? "",
      showError: showMissingLinkError,
      disabled: widget.disabled,
      onSendPressed: () {
        _sendMessage(widget.leads.first, controller.text);
      },
      onEmailSendPressed: () {
        _sendEmail(widget.leads.first, controller.text);
      },
    );
  }

  Widget _buildMultipleRecommendationsWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: tabController,
          tabs: widget.leads.map((lead) => Tab(text: lead.name)).toList(),
          dividerColor: Colors.transparent,
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: tabController,
            children: widget.leads.map((lead) {
              final controller = _textControllers[lead.id]!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RecommendationTextField(
                  controller: controller,
                  leadName: lead.name ?? "",
                  showError: showMissingLinkError,
                  disabled: widget.disabled,
                  onSendPressed: () {
                    _sendMessage(lead, controller.text);
                  },
                  onEmailSendPressed: () {
                    _sendEmail(lead, controller.text);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
