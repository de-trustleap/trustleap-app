import 'package:finanzbegleiter/application/images/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/image_section/landing_page_creator_image_section.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  @override
  void initState() {
    super.initState();
    id = UniqueID();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    return BlocListener<LandingPageCubit, LandingPageState>(
      listener: (context, state) {
        if (state is CreatedLandingPageSuccessState) {
          if (image != null) {
            BlocProvider.of<LandingPageImageBloc>(context).add(UploadLandingPageImageTriggeredEvent(
            rawImage: image,
            id: id.value));
          }
        }
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: themeData.colorScheme.background),
          child: ListView(children: [
            SizedBox(height: responsiveValue.isMobile ? 40 : 80),
            LandingPageCreatorImageSection(
                id: id, imageSelected: (tempImage) => image = tempImage),
            const SizedBox(height: 20),
            CenteredConstrainedWrapper(
                child: LandingPageCreatorForm(
              id: id,
              onSaveTap: (landingPage) {
                //if(image != null) {
                BlocProvider.of<LandingPageCubit>(context)
                    .createLangingPage(landingPage);
                //}
              },
            ))
          ])),
    );
  }
}
