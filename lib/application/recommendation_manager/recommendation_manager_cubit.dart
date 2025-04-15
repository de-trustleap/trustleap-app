import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'recommendation_manager_state.dart';

class RecommendationManagerCubit extends Cubit<RecommendationManagerState> {
  final RecommendationRepository recommendationRepo;
  RecommendationManagerCubit(this.recommendationRepo)
      : super(RecommendationManagerInitial());

  void getRecommendations(String? userID) {
    if (userID == null) {
      return;
    }
  }
}
