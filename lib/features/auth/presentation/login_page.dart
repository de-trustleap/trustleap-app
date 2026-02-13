import 'package:finanzbegleiter/features/auth/application/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/features/auth/presentation/widgets/login_form.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/auth_page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageTemplate(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: BlocProvider(
            create: (context) => Modular.get<SignInCubit>(),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
