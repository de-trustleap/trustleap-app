import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_overview.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerPage extends StatefulWidget {
  const RecommendationManagerPage({super.key});

  @override
  State<RecommendationManagerPage> createState() =>
      _RecommendationManagerPageState();
}

class _RecommendationManagerPageState extends State<RecommendationManagerPage> {
  CustomUser? currentUser;

  @override
  void initState() {
    super.initState();
    Modular.get<RecommendationManagerCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final recoManagerCubit = Modular.get<RecommendationManagerCubit>();

    return BlocConsumer<RecommendationManagerCubit, RecommendationManagerState>(
        bloc: recoManagerCubit,
        listener: (context, state) {
          if (state is RecommendationManagerGetUserSuccessState) {
            currentUser = state.user;
            Modular.get<RecommendationManagerCubit>()
                .getRecommendations(state.user.id.value);
          }
        },
        builder: (context, state) {
          if (state is RecommendationManagerLoadingState) {
            return const LoadingIndicator();
          } else {
            return Container(
                width: double.infinity,
                decoration: BoxDecoration(color: themeData.colorScheme.surface),
                child: _createContainerChildWidget(
                    state, responsiveValue, localization));
          }
        });
  }

  Widget _createContainerChildWidget(
      RecommendationManagerState state,
      ResponsiveBreakpointsData responsiveValue,
      AppLocalizations localization) {
    if (state is RecommendationGetRecosNoRecosState) {
      return EmptyPage(
          icon: Icons.person_add,
          title: "Keine Empfehlungen gefunden",
          subTitle:
              "Es wurden keine Empfehlungen gefunden. Du scheinst noch keine Empfehlung ausgesprochen zu haben. Im Empfehlungsmanager werden deine ausgesprochenen Empfehlungen angezeigt.",
          buttonTitle: "Empfehlung aussprechen",
          onTap: () {
            CustomNavigator.navigate(
                RoutePaths.homePath + RoutePaths.recommendationsPath);
            Modular.get<MenuCubit>().selectMenu(MenuItems.recommendations);
          });
    } else if (state is RecommendationGetRecosFailureState) {
      return ErrorView(
          title: "Es ist ein Fehler aufgetreten",
          message: DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization),
          callback: () => {
                Modular.get<RecommendationManagerCubit>()
                    .getRecommendations(currentUser?.id.value)
              });
    } else if (state is RecommendationGetRecosSuccessState) {
      return ListView(children: [
        SizedBox(height: responsiveValue.isMobile ? 40 : 80),
        CenteredConstrainedWrapper(
          child: RecommendationManagerOverview(
              recommendations: state.recoItems,
              isPromoter: currentUser?.role == Role.promoter ? true : false),
        )
      ]);
    } else {
      return const LoadingIndicator();
    }
  }
}
