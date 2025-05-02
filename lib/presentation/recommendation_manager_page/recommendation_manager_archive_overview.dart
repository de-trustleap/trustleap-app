import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerArchiveOverview extends StatefulWidget {
  const RecommendationManagerArchiveOverview({super.key});

  @override
  State<RecommendationManagerArchiveOverview> createState() =>
      _RecommendationManagerArchiveOverviewState();
}

class _RecommendationManagerArchiveOverviewState
    extends State<RecommendationManagerArchiveOverview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  CustomUser? currentUser;

  @override
  void initState() {
    super.initState();
    Modular.get<RecommendationManagerArchiveCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<RecommendationManagerArchiveCubit>();

    return BlocConsumer<RecommendationManagerArchiveCubit,
        RecommendationManagerArchiveState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is RecommendationManagerArchiveGetUserSuccessState) {
          currentUser = state.user;
          Modular.get<RecommendationManagerArchiveCubit>()
              .getArchivedRecommendations(state.user.id.value);
        }
      },
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
      return const EmptyPage(
          icon: Icons.archive,
          title: "Keine archivierten Empfehlungen gefunden",
          subTitle:
              "Du scheinst noch keine Empfehlungen archiviert zu haben. Es werden alle abgeschlossenen und nicht abgeschlossenen Empfehlungen im Archiv hinterlegt.",
          buttonTitle: "",
          onTap: null,
          isButtonHidden: true);
    } else if (state
        is RecommendationManagerArchiveGetRecommendationsFailureState) {
      return ErrorView(
          title: "Es ist ein Fehler aufgetreten",
          message: DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization),
          callback: () => {
                Modular.get<RecommendationManagerArchiveCubit>()
                    .getArchivedRecommendations(currentUser?.id.value)
              });
    } else if (state
        is RecommendationManagerArchiveGetRecommendationsSuccessState) {
      print("THE RECOS: ${state.recommendations}");
      return const Placeholder();
    } else {
      return const LoadingIndicator();
    }
  }
}
