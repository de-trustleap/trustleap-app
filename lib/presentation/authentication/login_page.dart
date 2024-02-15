import 'package:finanzbegleiter/application/authentication/signIn/sign_in_bloc.dart';
import 'package:finanzbegleiter/injection.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: BlocProvider(
                  create: (context) => sl<SignInBloc>(),
                  child: const LoginForm(),
                ))));
  }
}
