import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list.dart';
import 'package:flutter/material.dart';

class RecommendationManagerOverview extends StatefulWidget {
  final List<RecommendationItem> recommendations;
  final bool isPromoter;
  const RecommendationManagerOverview(
      {super.key, required this.recommendations, required this.isPromoter});

  @override
  State<RecommendationManagerOverview> createState() =>
      _RecommendationManagerOverviewState();
}

class _RecommendationManagerOverviewState
    extends State<RecommendationManagerOverview> {
  late List<RecommendationItem> filteredRecommendations;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredRecommendations = widget.recommendations;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredRecommendations = widget.recommendations.where((item) {
          final name = item.name?.toLowerCase() ?? "";
          final promoter = item.promoterName?.toLowerCase() ?? "";
          final reason = item.reason?.toLowerCase() ?? "";

          return name.contains(query) ||
              promoter.contains(query) ||
              reason.contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Meine Empfehlungen",
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: SearchBar(
                controller: _searchController,
                leading: const Icon(Icons.search),
                trailing: [
                  IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      tooltip: "",
                      icon: const Icon(Icons.close))
                ],
                hintText: "Suche...",
              )),
            ],
          ),
          const SizedBox(height: 20),
          RecommendationManagerList(
            recommendations: filteredRecommendations,
            isPromoter: widget.isPromoter,
          ),
        ],
      ),
    );
  }
}
