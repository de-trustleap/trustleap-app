import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/register_recommendors_form.dart';
import 'package:flutter/material.dart';

class RegisterRecommendorsView extends StatefulWidget {
  const RegisterRecommendorsView({super.key});

  @override
  State<RegisterRecommendorsView> createState() =>
      _RegisterRecommendorsViewState();
}

class _RegisterRecommendorsViewState extends State<RegisterRecommendorsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.background),
        child: ListView(children: [
          const SizedBox(height: 80),
          CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [RegisterRecommendorsForm(changesSaved: () => {
                    CustomSnackBar.of(context).showCustomSnackBar("Der neue Empfehlungsgeber wurde erfolgreich registriert!")
                  })])),
        ]));
  }
}
