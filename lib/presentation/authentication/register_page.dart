import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_form.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/auth_page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterPage extends StatelessWidget {
  final String? registrationCode;
  const RegisterPage({super.key, this.registrationCode});

  @override
  Widget build(BuildContext context) {
    return AuthPageTemplate(
      child: Center(
        child: BlocProvider(
          create: (context) => Modular.get<SignInCubit>(),
          child: RegisterForm(registrationCode: registrationCode),
        ),
      ),
    );
  }
}
