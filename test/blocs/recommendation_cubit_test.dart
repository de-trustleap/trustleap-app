import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../repositories/landingpage_repository_test.mocks.dart';
import '../repositories/user_repository_test.mocks.dart';

void main() {
  late RecommendationsCubit recommendationCubit;
  late MockUserRepository mockUserRepo;
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockLandingPageRepo = MockLandingPageRepository();
    recommendationCubit = RecommendationsCubit(mockUserRepo, mockLandingPageRepo);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recommendationCubit.state, RecommendationsInitial());
  });

  group("RecommendationCubit_GetUser", () {
    test("should call user repo when function is called", () async {
      // Given
    });
  });
}
