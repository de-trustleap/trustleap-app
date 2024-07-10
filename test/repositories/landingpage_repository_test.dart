

import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'landingpage_repository_test.mocks.dart';

@GenerateMocks([LandingPageRepository])
void main() {
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
  });

  group("LandingPageRepositoryImplementation_getAllLandingPages", () { 
    test("should return list of landingpages when call was successful", () async {

    });
  });
}