import 'package:finanzbegleiter/application/recommendations/recommendations_observer/recommendations_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromotersOverviewGrid extends StatelessWidget {
  final List<Promoter> promoters = [
    Promoter(
        id: UniqueID.fromUniqueString("1"),
        gender: Gender.male,
        firstName: "Stefan",
        lastName: "Platz",
        birthDate: "23.12.2023",
        email: "tester@test.de",
        thumbnailDownloadURL: null,
        registered: false,
        expiresAt: DateTime.now()),
    Promoter(
        id: UniqueID.fromUniqueString("2"),
        gender: Gender.male,
        firstName: "Markus",
        lastName: "Hans",
        birthDate: "23.12.2023",
        email: "tester@test.de",
        thumbnailDownloadURL: null,
        registered: false,
        expiresAt: DateTime.now()),
    Promoter(
        id: UniqueID.fromUniqueString("3"),
        gender: Gender.female,
        firstName: "Stefanie",
        lastName: "Heier",
        birthDate: "23.12.2023",
        email: "tester@test.de",
        thumbnailDownloadURL: null,
        registered: true,
        expiresAt: DateTime.now()),
    Promoter(
        id: UniqueID.fromUniqueString("4"),
        gender: Gender.male,
        firstName: "Jürgen",
        lastName: "Palinski",
        birthDate: "23.12.2023",
        email: "tester@test.de",
        thumbnailDownloadURL: null,
        registered: false,
        expiresAt: DateTime.now())
  ];

  PromotersOverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    return BlocBuilder<RecommendationsObserverCubit,
        RecommendationsObserverState>(
      builder: (context, state) {
        if (state is PromotersObserverSuccess) {
          return CardContainer(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Meine Empfehlungsgeber",
                    style: themeData.textTheme.headlineLarge!
                        .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                GridView.count(
                    crossAxisCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                    crossAxisSpacing:
                        responsiveValue.largerThan(MOBILE) ? 48 : 12,
                    mainAxisSpacing:
                        responsiveValue.largerThan(MOBILE) ? 48 : 12,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    childAspectRatio: 0.734,
                    children: List.generate(state.promoters.length, (index) {
                      // TODO: Hier sollen jetzt die echten Backend Daten angezeigt werden. Dafür ein paar Promoter erstellen.
                      return Center(
                          child: GridTile(
                              child: PromotersOverviewGridTile(
                                  promoter: state.promoters[index])));
                    }))
              ]));
        } else if (state is PromotersObserverFailure) {
          return ErrorView(
              title: "Ein Fehler beim Abruf der Daten ist aufgetreten.",
              message: DatabaseFailureMapper.mapFailureMessage(
                  state.failure, localization),
              callback: () => {
                    BlocProvider.of<RecommendationsObserverCubit>(context)
                        .observeAllPromoters()
                  });
        } else {
          print("THE STATE: $state");
          return const LoadingIndicator();
        }
      },
    );
  }
}
