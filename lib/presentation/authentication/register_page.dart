import 'package:finanzbegleiter/application/authentication/signIn/sign_in_bloc.dart';
import 'package:finanzbegleiter/application/authentication/user/user_bloc.dart';
import 'package:finanzbegleiter/injection.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SignInBloc>()),
        BlocProvider(create: (context) => sl<UserBloc>())
      ],
      child: const RegisterForm(),
    )));
  }
}
