import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/password_forgotten_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PasswordForgottenPage extends StatelessWidget {
  const PasswordForgottenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: BlocProvider<AuthCubit>(
                create: (context) => Modular.get<AuthCubit>(),
                child: const PasswordForgottenForm())));
  }
}
