import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary)));
  }
}
