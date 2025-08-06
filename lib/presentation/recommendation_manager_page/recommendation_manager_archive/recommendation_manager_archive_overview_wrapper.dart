import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive/recommendation_manager_archive_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerArchiveOverviewWrapper extends StatefulWidget {
  const RecommendationManagerArchiveOverviewWrapper({super.key});

  @override
  State<RecommendationManagerArchiveOverviewWrapper> createState() =>
      _RecommendationManagerArchiveOverviewState();
}

class _RecommendationManagerArchiveOverviewState
    extends State<RecommendationManagerArchiveOverviewWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  CustomUser? currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = BlocProvider.of<UserObserverCubit>(context).state;
      if (userState is UserObserverSuccess) {
        currentUser = userState.user;
        Modular.get<RecommendationManagerArchiveCubit>()
            .getArchivedRecommendations(userState.user.id.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<RecommendationManagerArchiveCubit>();

    return BlocBuilder<RecommendationManagerArchiveCubit,
        RecommendationManagerArchiveState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is RecommendationManagerArchiveLoadingState) {
          return const LoadingIndicator();
        } else {
          return Container(
              width: double.infinity,
              decoration: BoxDecoration(color: themeData.colorScheme.surface),
              child: _createContainerChildWidget(
                  state, responsiveValue, localization));
        }
      },
    );
  }

  Widget _createContainerChildWidget(
      RecommendationManagerArchiveState state,
      ResponsiveBreakpointsData responsiveValue,
      AppLocalizations localization) {
    if (state is RecommendationManagerArchiveNoRecosState) {
      return EmptyPage(
          icon: Icons.archive,
          title: localization.recommendation_manager_archive_no_data_title,
          subTitle:
              localization.recommendation_manager_archive_no_data_description,
          buttonTitle: "",
          onTap: null,
          isButtonHidden: true);
    } else if (state
        is RecommendationManagerArchiveGetRecommendationsFailureState) {
      return ErrorView(
          title: localization.recommendation_manager_failure_text,
          message: DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization),
          callback: () => {
                Modular.get<RecommendationManagerArchiveCubit>()
                    .getArchivedRecommendations(currentUser?.id.value)
              });
    } else if (state
        is RecommendationManagerArchiveGetRecommendationsSuccessState) {
      return ListView(children: [
        SizedBox(height: responsiveValue.isMobile ? 40 : 80),
        CenteredConstrainedWrapper(
            child: RecommendationManagerArchiveOverview(
                recommendations: state.recommendations,
                isPromoter: currentUser?.role == Role.promoter))
      ]);
    } else {
      return const LoadingIndicator();
    }
  }
}
