import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_reorder_section_helper.dart';
import 'package:rxdart/rxdart.dart';

part 'pagebuilder_event.dart';
part 'pagebuilder_state.dart';

class PagebuilderBloc extends Bloc<PagebuilderEvent, PagebuilderState> {
  final LandingPageRepository landingPageRepo;
  final PagebuilderRepository pageBuilderRepo;
  final UserRepository userRepo;

  PagebuilderBloc({
    required this.landingPageRepo,
    required this.pageBuilderRepo,
    required this.userRepo,
  }) : super(PagebuilderInitial()) {
    on<GetLandingPageEvent>(_onGetLandingPage);
    on<GetLandingPageContentEvent>(_onGetLandingPageContent);
    on<UpdateWidgetEvent>(_onUpdateWidget,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 100))
            .switchMap(mapper));
    on<UpdateSectionEvent>(_onUpdateSection,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 100))
            .switchMap(mapper));
    on<ReorderSectionsEvent>(_onReorderSections);
    on<SaveLandingPageContentEvent>(_onSaveLandingPageContent);
  }

  void _onReorderSections(
      ReorderSectionsEvent event, Emitter<PagebuilderState> emit) {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = PagebuilderReorderSectionHelper.reorderSections(
          sections, event.oldIndex, event.newIndex);

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);
      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);
      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }

  Future<void> _onGetLandingPage(
      GetLandingPageEvent event, Emitter<PagebuilderState> emit) async {
    if (event.id.isEmpty) {
      emit(GetLandingPageFailureState(failure: NotFoundFailure()));
      return;
    }

    emit(GetLandingPageLoadingState());

    final failureOrSuccess = await landingPageRepo.getLandingPage(event.id);
    failureOrSuccess.fold(
      (failure) => emit(GetLandingPageFailureState(failure: failure)),
      (landingPage) async {
        final failureOrSuccess = await userRepo.getUser();
        failureOrSuccess.fold(
          (failure) => emit(GetLandingPageFailureState(failure: failure)),
          (user) => add(GetLandingPageContentEvent(
            landingPage.contentID?.value ?? "",
            PagebuilderContent(
              landingPage: landingPage,
              content: null,
              user: user,
            ),
          )),
        );
      },
    );
  }

  Future<void> _onGetLandingPageContent(
      GetLandingPageContentEvent event, Emitter<PagebuilderState> emit) async {
    if (event.id.isEmpty) {
      emit(GetLandingPageFailureState(failure: NotFoundFailure()));
      return;
    }

    final failureOrSuccess =
        await pageBuilderRepo.getLandingPageContent(event.id);

    failureOrSuccess.fold(
      (failure) => emit(GetLandingPageFailureState(failure: failure)),
      (content) {
        final pageBuilderContent = event.pageContent.copyWith(content: content);
        emit(GetLandingPageAndUserSuccessState(
          content: pageBuilderContent,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: null,
          isUpdated: null,
        ));
      },
    );
  }

  void _onUpdateSection(
      UpdateSectionEvent event, Emitter<PagebuilderState> emit) {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final updatedSections =
          currentState.content.content?.sections?.map((section) {
        if (section.id == event.updatedSection.id) {
          return event.updatedSection;
        } else {
          return section;
        }
      }).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);
      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);
      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }

  void _onUpdateWidget(
      UpdateWidgetEvent event, Emitter<PagebuilderState> emit) {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;

      final updatedSections = currentState.content.content?.sections?.map(
        (section) {
          final updatedWidgets = section.widgets
              ?.map(
                (widget) => _updateChildWidgets(widget, event.updatedWidget),
              )
              .toList();
          return section.copyWith(widgets: updatedWidgets);
        },
      ).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);

      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);
      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }

  Future<void> _onSaveLandingPageContent(
      SaveLandingPageContentEvent event, Emitter<PagebuilderState> emit) async {
    if (event.content?.content == null) {
      emit(PageBuilderUnexpectedFailureState());
      return;
    }

    emit(GetLandingPageAndUserSuccessState(
      content: event.content!,
      saveLoading: true,
      saveFailure: null,
      saveSuccessful: null,
      isUpdated: null,
    ));

    final failureOrSuccess =
        await pageBuilderRepo.saveLandingPageContent(event.content!.content!);

    failureOrSuccess.fold(
      (failure) => emit(GetLandingPageAndUserSuccessState(
        content: event.content!,
        saveLoading: false,
        saveFailure: failure,
        saveSuccessful: null,
        isUpdated: null,
      )),
      (_) => emit(GetLandingPageAndUserSuccessState(
        content: event.content!,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: true,
        isUpdated: false,
      )),
    );
  }

  PageBuilderWidget _updateChildWidgets(
      PageBuilderWidget currentWidget, PageBuilderWidget updatedWidget) {
    if (currentWidget.id == updatedWidget.id) {
      return updatedWidget;
    }

    if (currentWidget.containerChild != null) {
      final updatedContainerChild =
          _updateChildWidgets(currentWidget.containerChild!, updatedWidget);
      return currentWidget.copyWith(containerChild: updatedContainerChild);
    }

    if (currentWidget.children != null && currentWidget.children!.isNotEmpty) {
      final updatedChildren = currentWidget.children!
          .map(
            (child) => _updateChildWidgets(child, updatedWidget),
          )
          .toList();

      return currentWidget.copyWith(children: updatedChildren);
    }

    return currentWidget;
  }
}
