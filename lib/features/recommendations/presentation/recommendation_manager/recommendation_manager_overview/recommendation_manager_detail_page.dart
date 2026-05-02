import 'package:finanzbegleiter/core/widgets/page_wrapper/native_appbar_override_scope.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_detail_args.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_detail_content.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManagerDetailPage extends StatefulWidget {
  final RecommendationDetailArgs args;

  const RecommendationManagerDetailPage({super.key, required this.args});

  @override
  State<RecommendationManagerDetailPage> createState() =>
      _RecommendationManagerDetailPageState();
}

class _RecommendationManagerDetailPageState
    extends State<RecommendationManagerDetailPage> {
  bool _didInitOverrides = false;
  NativeAppBarOverrideScope? _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = NativeAppBarOverrideScope.of(context);
    if (_didInitOverrides) return;
    _didInitOverrides = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final scope = _scope;
      if (scope == null) return;

      final cubit = Modular.get<RecommendationManagerTileCubit>();
      final title =
          widget.args.recommendation.recommendation?.displayName?.isNotEmpty ==
                  true
              ? widget.args.recommendation.recommendation!.displayName!
              : widget.args.recommendation.recommendation?.promoterName ?? '';

      scope.titleOverride.value = title;
      scope.actionsOverride.value = [
        BlocBuilder<RecommendationManagerTileCubit,
            RecommendationManagerTileState>(
          bloc: cubit,
          builder: (context, _) => RecommendationManagerFavoriteButton(
            isFavorite: cubit.currentFavoriteRecommendationIDs
                .contains(widget.args.recommendation.id.value),
            onPressed: () =>
                widget.args.onFavoritePressed(widget.args.recommendation),
          ),
        ),
      ];
    });
  }

  @override
  void dispose() {
    final scope = _scope;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scope?.titleOverride.value = null;
      scope?.actionsOverride.value = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecommendationManagerDetailContent(
      recommendation: widget.args.recommendation,
      buildContent: widget.args.buildContent,
      buildBottomRowTrailing: widget.args.buildBottomRowTrailing,
    );
  }
}
