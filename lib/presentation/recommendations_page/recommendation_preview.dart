import 'package:finanzbegleiter/domain/entities/leadItem.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_template_placeholder.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/LeadTextField.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationPreview extends StatefulWidget {
  final List<LeadItem> leads; // Liste der Leads (Namen und Gründe)

  const RecommendationPreview({super.key, required this.leads});

  @override
  State<RecommendationPreview> createState() => _RecommendationPreviewState();
}

class _RecommendationPreviewState extends State<RecommendationPreview>
    with TickerProviderStateMixin {
  TabController? tabController;
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();

    // Für alle Leads, die beim ersten Aufbau vorhanden sind, Controller anlegen
    for (final lead in widget.leads) {
      final text = parseTemplate(lead, lead.promotionTemplate);
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
        final text = parseTemplate(lead, lead.promotionTemplate);
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
    super.dispose();
  }

  // Hilfsfunktion, um mehrere Platzhalter zu ersetzen
  String parseTemplate(LeadItem lead, String template) {
    final serviceProviderLastName =
        (lead.serviceProviderName.split(" ")).skip(1).join(" ");
    final promoterLastName = (lead.promoterName.split(" ")).skip(1).join(" ");
    final replacements = {
      LandingPageTemplatePlaceholder.receiverName: lead.name,
      LandingPageTemplatePlaceholder.providerFirstName:
          lead.serviceProviderName.split(" ").first,
      LandingPageTemplatePlaceholder.providerLastName: serviceProviderLastName,
      LandingPageTemplatePlaceholder.providerName:
          "${lead.serviceProviderName.split(" ").first} $serviceProviderLastName",
      LandingPageTemplatePlaceholder.promoterFirstName:
          lead.promoterName.split(" ").first,
      LandingPageTemplatePlaceholder.promoterLastName: promoterLastName,
      LandingPageTemplatePlaceholder.promoterName:
          "${lead.promoterName.split(" ").first} $promoterLastName"
    };

    var result = template;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  Future<void> _sendMessage(String leadName, String message) async {
    final localization = AppLocalizations.of(context);
    final whatsappUrl = Uri.parse(
        "https://api.whatsapp.com/send/?text=${Uri.encodeComponent(message)}");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      CustomSnackBar.of(context).showCustomSnackBar(
          localization.recommendation_page_send_whatsapp_error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Falls nur ein Lead vorhanden ist, brauchst du evtl. kein TabBar
    if (widget.leads.length <= 1) {
      final lead = widget.leads.isNotEmpty ? widget.leads.first : null;
      if (lead == null) {
        return const SizedBox();
      }
      // Wir verwenden hier den Controller aus der Map
      final controller = _textControllers[lead.id]!;
      return SizedBox(
        height: 250,
        child: LeadTextField(
          controller: controller,
          leadName: lead.name,
          onSendPressed: () {
            _sendMessage(
              widget.leads.first.name,
              controller.text,
            );
          },
        ),
      );
    }

    // Bei mehreren Leads → TabBar
    return Column(
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
                child: LeadTextField(
                  controller: controller,
                  leadName: lead.name,
                  onSendPressed: () {
                    _sendMessage(lead.name, controller.text);
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
