import 'package:finanzbegleiter/application/images/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
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
  Uint8List? image;
  bool showNoImageFailureMessage = false;

  @override
  void initState() {
    super.initState();
    id = UniqueID();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<LandingPageCubit, LandingPageState>(
              listener: (context, state) {
            if (image != null && state is CreatedLandingPageSuccessState) {
              BlocProvider.of<LandingPageImageBloc>(context).add(
                  UploadLandingPageImageTriggeredEvent(
                      rawImage: image, id: id.value));
            } else if (state is CreatedLandingPageSuccessState) {
              print("SUCCESS!!");
            }
          }),
          BlocListener<LandingPageImageBloc, LandingPageImageState>(
              listener: (context, state) {
            if (state is LandingPageImageUploadSuccessState) {
              print("UPLOAD SUCCESSFUL");
              Modular.to
                  .navigate(RoutePaths.homePath + RoutePaths.landingPagePath);
            }
          })
        ],
        child: BlocBuilder<LandingPageImageBloc, LandingPageImageState>(
          builder: (context, imageState) {
            return BlocBuilder<LandingPageCubit, LandingPageState>(
              builder: (context, landingPageState) {
                return Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: themeData.colorScheme.background),
                    child: ListView(children: [
                      SizedBox(height: responsiveValue.isMobile ? 40 : 80),
                      LandingPageCreatorImageSection(
                          id: id,
                          failureState: imageState,
                          imageSelected: (tempImage) => image = tempImage),
                      const SizedBox(height: 20),
                      CenteredConstrainedWrapper(
                          child: LandingPageCreatorForm(
                        id: id,
                        onSaveTap: (landingPage) {
                          if (image != null) {
                            setState(() {
                              showNoImageFailureMessage = false;
                            });
                            BlocProvider.of<LandingPageCubit>(context)
                                .createLangingPage(landingPage);
                          } else {
                            setState(() {
                              showNoImageFailureMessage = true;
                            });
                          }
                        },
                      )),
                      if (imageState is LandingPageImageUploadLoadingState) ...[
                        const SizedBox(height: 20),
                        const LoadingIndicator()
                      ],
                      if (showNoImageFailureMessage) ...[
                        const SizedBox(height: 20),
                        const CenteredConstrainedWrapper(
                            child: FormErrorView(
                                message: "Bitte ein Bild hochladen"))
                      ]
                    ]));
              },
            );
          },
        ));
  }
}
