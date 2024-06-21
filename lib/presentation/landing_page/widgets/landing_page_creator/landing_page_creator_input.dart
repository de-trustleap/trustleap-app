import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/image_section/landing_page_creator_image_section.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorInput extends StatefulWidget {
  const LandingPageCreatorInput({super.key});

  @override
  State<LandingPageCreatorInput> createState() =>
      _LandingPageCreatorInputState();
}

class _LandingPageCreatorInputState extends State<LandingPageCreatorInput> {
  late UniqueID id;
  Company? company;
  Uint8List? image;
  bool showNoImageFailureMessage = false;

  @override
  void initState() {
    super.initState();
    id = UniqueID();
    BlocProvider.of<LandingPageCubit>(context).getUser();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<LandingPageCubit, LandingPageState>(
              listener: (context, state) {
            if (state is CreatedLandingPageSuccessState) {
              Modular.to
                  .navigate(RoutePaths.homePath + RoutePaths.landingPagePath);
            } else if (state is GetUserSuccessState) {
              if (state.user.companyID != null) {
                BlocProvider.of<CompanyCubit>(context)
                    .getCompany(state.user.companyID!);
              }
            }
          }),
          BlocListener<CompanyCubit, CompanyState>(listener: (context, state) {
            if (state is GetCompanySuccessState) {
              setState(() {
                company = state.company;
              });
            }
          })
        ],
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: themeData.colorScheme.background),
            child: ListView(children: [
              SizedBox(height: responsiveValue.isMobile ? 40 : 80),
              LandingPageCreatorImageSection(
                  id: id,
                  company: company,
                  imageSelected: (tempImage) => image = tempImage),
              const SizedBox(height: 20),
              CenteredConstrainedWrapper(
                  child: LandingPageCreatorForm(
                id: id,
                onSaveTap: (landingPage) {
                  if (image != null ||
                      company?.companyImageDownloadURL != null) {
                    setState(() {
                      showNoImageFailureMessage = false;
                    });
                    BlocProvider.of<LandingPageCubit>(context)
                        .createLangingPage(landingPage, image!);
                  } else {
                    setState(() {
                      showNoImageFailureMessage = true;
                    });
                  }
                },
              )),
              if (showNoImageFailureMessage) ...[
                const SizedBox(height: 20),
                const CenteredConstrainedWrapper(
                    child: FormErrorView(message: "Bitte ein Bild hochladen"))
              ]
            ])));
  }
}
