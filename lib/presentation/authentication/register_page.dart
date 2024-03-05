import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => Modular.get<SignInCubit>()),
        BlocProvider(create: (context) => Modular.get<UserCubit>())
      ],
      child: const RegisterForm(),
    )));
  }
}
