import 'package:finanzbegleiter/domain/entities/leadItem.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
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
  List<TextEditingController> textControllers = [];

  @override
  void initState() {
    super.initState();

    // TabController initialisieren wenn mehrere leads
    if (widget.leads.length > 1) {
      tabController = TabController(length: widget.leads.length, vsync: this);
    }

   // TextEditingController für jeden Lead erstellen
    textControllers = List.generate(
      widget.leads.length,
      (index) => TextEditingController(
        text: parseTemplate(widget.leads[index], widget.leads[index].promotionTemplate),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant RecommendationPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.leads.length > 1) {
      tabController = TabController(length: widget.leads.length, vsync: this);
    } else {
      tabController = null;
    }

    textControllers = List.generate(
      widget.leads.length,
      (index) => TextEditingController(
        text: parseTemplate(widget.leads[index], widget.leads[index].promotionTemplate),
      ),
    );
  }

  @override
  void dispose() {
    tabController?.dispose();
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Hilfsfunktion, um mehrere Platzhalter zu ersetzen
  String parseTemplate(LeadItem lead, String template) {
    // Passen Sie diese Map auf Ihre Felder an
    final replacements = {
      "\$name": lead.name
    };

    var result = template;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });

    return result;
  }

  Future<void> _sendMessage(String leadName, String message) async {
    final whatsappUrl = Uri.parse("https://api.whatsapp.com/send/?text=${Uri.encodeComponent(message)}");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp ist nicht installiert oder kann nicht geöffnet werden.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wenn nur ein Lead vorhanden ist, brauchen wir keine Tabs
    final isSingleLead = widget.leads.length == 1;

    return CardContainer(
      maxWidth: 800,
      child: isSingleLead
          ? SizedBox(
              height: 250,
              child: LeadTextField(
                controller: textControllers.first,
                leadName: widget.leads.first.name,
                onSendPressed: () {
                  _sendMessage(
                    widget.leads.first.name,
                    textControllers.first.text,
                  );
                },
              ),
            )
          : Column(
              children: [
                TabBar(
                  controller: tabController,
                  tabs: widget.leads.map((lead) => Tab(text: lead.name)).toList(),
                  dividerColor: Colors.transparent,
                ),
                SizedBox(
                  height: 250,
                  child: TabBarView(
                    controller: tabController,
                    children: widget.leads
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LeadTextField(
                              controller: textControllers[entry.key],
                              leadName: entry.value.name,
                              onSendPressed: () {
                                _sendMessage(
                                  entry.value.name,
                                  textControllers[entry.key].text,
                                );
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}