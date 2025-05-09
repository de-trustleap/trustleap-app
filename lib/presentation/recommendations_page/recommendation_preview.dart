import 'dart:async';

import 'package:finanzbegleiter/application/recommendations/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_template_placeholder.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_confirmation_dialog.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_confirmation_dialog_error.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_confirmation_dialog_loading.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

class RecommendationPreview extends StatefulWidget {
  final String userID;
  final List<RecommendationItem> leads;
  final Function(RecommendationItem) onSaveSuccess;

  const RecommendationPreview(
      {super.key,
      required this.userID,
      required this.leads,
      required this.onSaveSuccess});

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

  @override
  void initState() {
    super.initState();

    // Für alle Leads, die beim ersten Aufbau vorhanden sind, Controller anlegen
    for (final lead in widget.leads) {
      final text = parseTemplate(lead, lead.promotionTemplate ?? "");
      // Lead muss eine eindeutige ID haben
      _textControllers[lead.id] = TextEditingController(text: text);
    }

    // Falls wir mehr als einen Lead haben, TabController initialisieren
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

    // 1) Controller entfernen, die zu Leads gehören,
    // die jetzt nicht mehr existieren
    final oldIds = oldWidget.leads.map((l) => l.id).toSet();
    final newIds = widget.leads.map((l) => l.id).toSet();

    // leads, die entfernt wurden
    final removedIds = oldIds.difference(newIds);
    for (final id in removedIds) {
      _textControllers[id]?.dispose();
      _textControllers.remove(id);
    }

    // 2) Neue Controller nur für hinzugekommene Leads anlegen
    for (final lead in widget.leads) {
      if (!_textControllers.containsKey(lead.id)) {
        final text = parseTemplate(lead, lead.promotionTemplate ?? "");
        _textControllers[lead.id] = TextEditingController(text: text);
      }
    }

    // 3) TabController anpassen, falls sich die Länge ändert
    if (widget.leads.length > 1) {
      // Bei geändertem TabCount einen neuen TabController erstellen
      if (tabController == null ||
          tabController!.length != widget.leads.length) {
        tabController?.dispose();
        tabController = TabController(
          length: widget.leads.length,
          vsync: this,
        );
      }
    } else {
      // Bei nur einem Lead oder keinem Lead TabController entfernen
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

  // Hilfsfunktion, um mehrere Platzhalter zu ersetzen
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
    final baseURL = Environment().getLandingpageBaseURL();
    final link = "$baseURL?id=${recommendation.id}";

    var adaptedMessage = "";
    if (!message.contains("[LINK]")) {
      setState(() {
        showMissingLinkError = true;
      });
      return;
    }
    setState(() {
      showMissingLinkError = false;
    });

    adaptedMessage = message.replaceAll("[LINK]", link);
    final localization = AppLocalizations.of(context);
    final whatsappURL =
        "https://api.whatsapp.com/send/?text=${Uri.encodeComponent(adaptedMessage)}";
    final convertedURL = Uri.parse(whatsappURL);
    if (kIsWeb) {
      web.window.open(whatsappURL, '_blank');
      _startComeBackToPageListener(recommendation);
      return;
    } else {
      if (await canLaunchUrl(convertedURL)) {
        await launchUrl(convertedURL, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        CustomSnackBar.of(context).showCustomSnackBar(
            localization.recommendation_page_send_whatsapp_error);
      }
    }
  }

  void _startComeBackToPageListener(RecommendationItem recommendation) {
    _visibilitySubscription?.cancel();
    _visibilitySubscription = web.document.onVisibilityChange.listen((event) {
      if (!web.document.hidden && mounted && !isAlertVisible) {
        isAlertVisible = true;
        // App ist wieder sichtbar (zurück im Tab)
        showDialog(
            context: context,
            builder: (_) {
              return RecommendationConfirmationDialog(
                  recommendationReceiverName: recommendation.name,
                  cancelAction: () {
                    isAlertVisible = false;
                    CustomNavigator.pop();
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
    final recoCubit = Modular.get<RecommendationsAlertCubit>();
    return BlocListener<RecommendationsAlertCubit, RecommendationsAlertState>(
      bloc: recoCubit,
      listener: (context, state) {
        if (state is RecommendationSaveLoadingState) {
          if (isAlertVisible) {
            CustomNavigator.pop();
            showDialog(
                context: context,
                builder: (_) {
                  return RecommendationConfirmationDialogLoading(
                      cancelAction: () {
                        isAlertVisible = false;
                        CustomNavigator.pop();
                      },
                      action: () => _onRecommendationSentSuccessful(
                          state.recommendation));
                });
          }
        } else if (state is RecommendationSaveFailureState) {
          if (isAlertVisible) {
            CustomNavigator.pop();
            showDialog(
                context: context,
                builder: (_) {
                  return RecommendationConfirmationDialogError(
                      failure: state.failure,
                      recommendationReceiverName: state.recommendation.name,
                      cancelAction: () {
                        isAlertVisible = false;
                        CustomNavigator.pop();
                      },
                      action: () => _onRecommendationSentSuccessful(
                          state.recommendation));
                });
          }
        } else if (state is RecommendationSaveSuccessState) {
          if (isAlertVisible) {
            isAlertVisible = false;
            CustomNavigator.pop();
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
    return SizedBox(
      height: 250,
      child: RecommendationTextField(
        controller: controller,
        leadName: lead.name ?? "",
        showError: showMissingLinkError,
        onSendPressed: () {
          _sendMessage(widget.leads.first, controller.text);
        },
      ),
    );
  }

  Widget _buildMultipleRecommendationsWidget() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: widget.leads.map((lead) => Tab(text: lead.name)).toList(),
          dividerColor: Colors.transparent,
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: tabController,
            children: widget.leads.map((lead) {
              final controller = _textControllers[lead.id]!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RecommendationTextField(
                      controller: controller,
                      leadName: lead.name ?? "",
                      showError: showMissingLinkError,
                      onSendPressed: () {
                        _sendMessage(lead, controller.text);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
