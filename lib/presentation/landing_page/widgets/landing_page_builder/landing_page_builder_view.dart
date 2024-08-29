import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPageBuilderView extends StatefulWidget {
  const LandingPageBuilderView({super.key});

  @override
  State<LandingPageBuilderView> createState() => _LandingPageBuilderViewState();
}

class _LandingPageBuilderViewState extends State<LandingPageBuilderView> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<MenuCubit>(context).collapseMenu(true);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
