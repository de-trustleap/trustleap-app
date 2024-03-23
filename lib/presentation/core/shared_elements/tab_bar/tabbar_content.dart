// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:flutter/material.dart';

class TabbarContent {
  final CustomTab tab;
  final Widget content;

  TabbarContent({
    required this.tab,
    required this.content,
  });
}
