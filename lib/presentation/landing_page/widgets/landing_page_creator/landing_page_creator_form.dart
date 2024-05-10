import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorForm extends StatefulWidget {
  const LandingPageCreatorForm({super.key});

  @override
  State<LandingPageCreatorForm> createState() => _LandingPageCreatorFormState();
}

class _LandingPageCreatorFormState extends State<LandingPageCreatorForm> {
  final nameTextController = TextEditingController();
  final textTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomUser? user;

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LandingPageCubit>(context).getUser();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    textTextController.dispose();

    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void submit(LandingPageCreatorFormValidator validator) {
    if (formKey.currentState!.validate() && user != null) {
      validationHasError = false;
      BlocProvider.of<LandingPageCubit>(context).createLangingPage(
        LandingPage(id: UniqueID()
        , name: nameTextController.text.trim()
        , text: textTextController.text.trim()
        , parentUserId: user!.id)
          );
    } else {
      validationHasError = true;
      BlocProvider.of<LandingPageCubit>(context).createLangingPage(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator =
        LandingPageCreatorFormValidator(localization: localization);
    const double textFieldSpacing = 20;

    return BlocConsumer<LandingPageCubit, LandingPageState>(
      listener: (context, state) {
        if(state is GetUserSuccessState) {
          setState(() {
            user = state.user;
          });
        } else if (state is GetUserFailureState) {
            // TODO: Handle User FailureState
        }
      },
      builder: (context, state) {
        return CardContainer(
            child: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Form(
              key: formKey,
              autovalidateMode: validationHasError
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Landingpage erstellen!",
                        style: themeData.textTheme.headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FormTextfield(
                          maxWidth: maxWidth,
                          controller: nameTextController,
                          disabled: false,
                          placeholder: "Title",
                          onChanged: resetError,
                          validator: validator.validateLandingPageName)
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FormTextfield(
                          maxWidth: maxWidth,
                          controller: textTextController,
                          disabled: false,
                          placeholder: "Text",
                          onChanged: resetError,
                          validator: validator.validateLandingPageText,
                          minLines: 2,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline)
                    ]),
                    const SizedBox(height: textFieldSpacing * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PrimaryButton(
                            title: "LandingPage erstellen",
                            width: responsiveValue.isMobile
                                ? maxWidth - textFieldSpacing
                                : maxWidth / 2 - textFieldSpacing,
                            onTap: () {
                              submit(validator);
                            })
                      ],
                    ),
                  ]));
        }));
      },
    );
  }
}
