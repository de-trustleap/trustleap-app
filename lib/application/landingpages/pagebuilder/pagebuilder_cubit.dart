import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'pagebuilder_state.dart';

class PagebuilderCubit extends Cubit<PagebuilderState> {
  final LandingPageRepository landingPageRepo;
  final PagebuilderRepository pageBuilderRepo;
  final UserRepository userRepo;

  PagebuilderCubit(this.landingPageRepo, this.pageBuilderRepo, this.userRepo)
      : super(PagebuilderInitial());

  void getLandingPage(String id) async {
    if (id.isEmpty) {
      emit(GetLandingPageFailureState(failure: NotFoundFailure()));
    } else {
      emit(GetLandingPageLoadingState());
      final failureOrSuccess = await landingPageRepo.getLandingPage(id);
      failureOrSuccess
          .fold((failure) => emit(GetLandingPageFailureState(failure: failure)),
              (landingPage) async {
        final failureOrSuccess = await userRepo.getUser();
        failureOrSuccess.fold(
            (failure) => emit(GetLandingPageFailureState(failure: failure)),
            (user) => getLandingPageContent(
                landingPage.contentID?.value ?? "",
                PagebuilderContent(
                    landingPage: landingPage, content: null, user: user)));
      });
    }
  }

  void getLandingPageContent(String id, PagebuilderContent pageContent) async {
    if (id.isEmpty) {
      emit(GetLandingPageFailureState(failure: NotFoundFailure()));
    } else {
      final failureOrSuccess = await pageBuilderRepo.getLandingPageContent(id);
      failureOrSuccess
          .fold((failure) => emit(GetLandingPageFailureState(failure: failure)),
              (content) {
        final pageBuilderContent = pageContent.copyWith(content: content);
        emit(GetLandingPageAndUserSuccessState(content: pageBuilderContent, saveLoading: false, saveFailure: null));
      });
    }
  }

  void updateWidget(PageBuilderWidget updatedWidget) {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final updatedSections =
          currentState.content.content?.sections?.map((section) {
        final updatedWidgets = section.widgets?.map((widget) {
          return widget.id == updatedWidget.id ? updatedWidget : widget;
        }).toList();
        return section.copyWith(widgets: updatedWidgets);
      }).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);
      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);
      emit(GetLandingPageAndUserSuccessState(
          content: updatedPageBuilderContent, saveLoading: false, saveFailure: null));
    }
  }

  void saveLandingPageContent(PageBuilderPage? page) async {
    if (page == null) {
      emit(PageBuilderUnexpectedFailureState());
    } else if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      emit(GetLandingPageAndUserSuccessState(content: currentState.content, saveLoading: true, saveFailure: null));
      final failureOrSuccess = await pageBuilderRepo.saveLandingPageContent(page);
      failureOrSuccess.fold(
        (failure) => emit(GetLandingPageAndUserSuccessState(content: currentState.content, saveLoading: false, saveFailure: failure)),
        (_) => emit(GetLandingPageAndUserSuccessState(content: currentState.content, saveLoading: false, saveFailure: null)));
    } else {
      emit(PageBuilderUnexpectedFailureState());
    }
  }
}
