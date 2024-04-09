import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';

class RecommendationsForm extends StatefulWidget {
  const RecommendationsForm({super.key});

  @override
  State<RecommendationsForm> createState() => _RecommendationsFormState();
}

class _RecommendationsFormState extends State<RecommendationsForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      return Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Empfehlungsformular",
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
          ]));
    }));
  }
}
