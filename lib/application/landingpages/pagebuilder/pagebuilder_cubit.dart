import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'pagebuilder_state.dart';

class PagebuilderCubit extends Cubit<PagebuilderState> {
  final LandingPageRepository landingPageRepo;
  final UserRepository userRepo;
  
  PagebuilderCubit(this.landingPageRepo, this.userRepo) : super(PagebuilderInitial());

  void getLandingPage(String id) async {
    if (id.isEmpty) {
      emit(GetLandingPageFailureState(failure: NotFoundFailure()));
    } else {
      emit(GetLandingPageLoadingState());
      final failureOrSuccess = await landingPageRepo.getLandingPage(id);
      failureOrSuccess.fold(
        (failure) => emit(GetLandingPageFailureState(failure: failure)),
        (landingPage) async {
          final failureOrSuccess = await userRepo.getUser();
          failureOrSuccess.fold(
            (failure) => emit(GetLandingPageFailureState(failure: failure)),
            (user) => emit(GetLandingPageAndUserSuccessState(landingPage: landingPage, user: user))
          );
        });
    }
  }
}
