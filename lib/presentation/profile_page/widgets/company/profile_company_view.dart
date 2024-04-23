// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/cached_image_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company/company_contact_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company/company_image_section.dart';

class ProfileCompanyView extends StatefulWidget {
  final CustomUser user;
  final String companyID;

  const ProfileCompanyView(
      {super.key, required this.user, required this.companyID});

  @override
  State<ProfileCompanyView> createState() => _ProfileCompanyViewState();
}

class _ProfileCompanyViewState extends State<ProfileCompanyView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CompanyObserverCubit>(context)
        .observeCompany(widget.companyID);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final companyObserverCubit = Modular.get<CompanyObserverCubit>();

    return BlocBuilder<CompanyObserverCubit, CompanyObserverState>(
      builder: (context, state) {
        if (state is CompanyObserverSuccess) {
          return Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(color: themeData.colorScheme.background),
              child: ListView(children: [
                SizedBox(height: responsiveValue.isMobile ? 40 : 80),
                CenteredConstrainedWrapper(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.user.role == Role.company) ...[
                      CompanyImageSection(
                          company: state.company, // TODO: Localizations nachziehen
                          imageUploadSuccessful: () => {
                                CustomSnackBar.of(context).showCustomSnackBar(
                                    localization
                                        .profile_page_snackbar_image_changed_message)
                              }),
                    ] else ...[
                      CachedImageView(
                          imageSize: const Size(200, 200),
                          imageDownloadURL: state.company.companyImageDownloadURL ?? "",
                          thumbnailDownloadURL:
                              state.company.thumbnailDownloadURL ?? "",
                          hovered: false)
                    ],
                    const SizedBox(height: 20),
                    CompanyContactSection(
                        user: widget.user,
                        company: state.company,
                        changesSaved: () {
                          CustomSnackBar.of(context).showCustomSnackBar(
                              "Unternehmensinformationen erfolgreich geändert");
                        }),
                    SizedBox(height: responsiveValue.isMobile ? 50 : 100)
                  ],
                ))
              ]));
        } else if (state is CompanyObserverFailure) {
          return CenteredConstrainedWrapper(
              child: ErrorView(
                  title: localization.profile_page_request_failure_message,
                  message: DatabaseFailureMapper.mapFailureMessage(
                      state.failure, localization),
                  callback: () =>
                      {companyObserverCubit.observeCompany(widget.companyID)}));
        } else {
          return CenteredConstrainedWrapper(
              child: CircularProgressIndicator(
                  color: themeData.colorScheme.secondary));
        }
      },
    );
  }
}
