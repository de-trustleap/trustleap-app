import 'package:flutter/material.dart';

class LandingPageSite extends StatelessWidget {
  final String landingPageId;
  const LandingPageSite({super.key, required this.landingPageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('landingPageId Page')),
      body: Center(
        child: Text('landingPageId: $landingPageId'),
      ),
    );
  }
}
