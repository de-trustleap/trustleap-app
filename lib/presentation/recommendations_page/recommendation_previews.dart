import 'package:finanzbegleiter/domain/entities/leadItem.dart';
import 'package:flutter/material.dart';

class RecommendationPreviews extends StatefulWidget {
  final LeadItem lead; // Liste der Leads (Namen und Gründe)
  

  const RecommendationPreviews({super.key, required this.lead});

  @override
  State<RecommendationPreviews> createState() => _RecommendationPreviewState();
}

class _RecommendationPreviewState extends State<RecommendationPreviews>
    with TickerProviderStateMixin {
  TextEditingController? controller;
  List<TextEditingController> textControllers = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.lead.name);
  }

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller, // Füllung mit dem fixen Inhalt
      decoration: InputDecoration(
        labelText: 'Lead',
        border: OutlineInputBorder(),
      ),
    );
  }
}
