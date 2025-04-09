import 'package:finanzbegleiter/domain/entities/lead_item.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:flutter/material.dart';

class RecommendationPreviews extends StatefulWidget {
  final LeadItem lead; // Liste der Leads (Namen und Gründe)
  const RecommendationPreviews({super.key, required this.lead});

  @override
  State<RecommendationPreviews> createState() => _RecommendationPreviewState();
}

class _RecommendationPreviewState extends State<RecommendationPreviews>
    with TickerProviderStateMixin {
  late TextEditingController controller;
  List<TextEditingController> textControllers = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.lead.name);
  }

  @override
  Widget build(BuildContext context) {
    return FormTextfield(
      controller: controller, // Füllung mit dem fixen Inhalt
      placeholder: '',
      disabled: false,
    );
  }
}
