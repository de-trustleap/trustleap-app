import 'package:finanzbegleiter/application/authentication/auth_bloc.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final validator = AuthValidator();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Form(
            key: formKey,
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 80),
                  Text("Registrieren",
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4)),
                  const SizedBox(height: 20),
                  Text("Registriere dich jetzt um den Service zu nutzen",
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4)),
                  const SizedBox(height: 80),
                  TextFormField(
                    controller: emailTextController,
                    validator: validator.validateEmail,
                    decoration: const InputDecoration(labelText: "E-Mail"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordTextController,
                    validator: validator.validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Passwort"),
                  ),
                  const SizedBox(height: 20),
                  AuthButton(
                      title: "Registrieren",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(
                              RegisterWithEmailAndPasswordPressed(
                                  email: emailTextController.text,
                                  password: passwordTextController.text));
                        } else {
                          BlocProvider.of<AuthBloc>(context).add(
                              RegisterWithEmailAndPasswordPressed(
                                  email: null, password: null));
                        }
                      }),
                  if (state.isSubmitting) ...[
                    const SizedBox(height: 80),
                    Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                              color: themeData.colorScheme.secondary)),
                    )
                  ]
                ]));
      },
    );
  }
}
