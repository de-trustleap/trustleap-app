import 'package:flutter/material.dart';

class LeadTextField extends StatelessWidget {
  final TextEditingController controller;
  final String leadName;
  final void Function()? onSendPressed;

  const LeadTextField({
    Key? key,
    required this.controller,
    required this.leadName,
    this.onSendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Text für $leadName",
              border: const OutlineInputBorder(),
            ),
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onSendPressed,
          icon: const Icon(Icons.send),
          label: const Text("Abschicken"),
        ),
      ],
    );
  }
}