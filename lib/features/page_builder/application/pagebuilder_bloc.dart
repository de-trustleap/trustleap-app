import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_content.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_local_history.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/features/page_builder/helpers/pagebuilder_widget_tree_manipulator.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_page_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_section_model.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/pagebuilder_reorder_helper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/pagebuilder_widget_factory.dart';
import 'package:rxdart/rxdart.dart';

part 'pagebuilder_bloc_history.dart';
part 'pagebuilder_bloc_section.dart';
part 'pagebuilder_bloc_widget.dart';
part 'pagebuilder_event.dart';
part 'pagebuilder_state.dart';

class PagebuilderBloc extends Bloc<PagebuilderEvent, PagebuilderState> {
  final LandingPageRepository landingPageRepo;
  final PagebuilderRepository pageBuilderRepo;
  final UserRepository userRepo;

  final PagebuilderLocalHistory localHistory = PagebuilderLocalHistory();
  bool isUndoRedoOperation = false;

  static const updateDebounceTime = Duration(milliseconds: 100);

  PagebuilderBloc({
    required this.landingPageRepo,
    required this.pageBuilderRepo,
    required this.userRepo,
  }) : super(PagebuilderInitial()) {
    on<GetLandingPageEvent>(_onGetLandingPage);
    on<GetLandingPageContentEvent>(_onGetLandingPageContent);
    on<UpdateWidgetEvent>(onUpdateWidget,
        transformer: (events, mapper) =>
            events.debounceTime(updateDebounceTime).switchMap(mapper));
    on<UpdateSectionEvent>(onUpdateSection,
        transformer: (events, mapper) =>
            events.debounceTime(updateDebounceTime).switchMap(mapper));
    on<UpdatePageEvent>(onUpdatePage,
        transformer: (events, mapper) =>
            events.debounceTime(updateDebounceTime).switchMap(mapper));
    on<UpdateGlobalStylesEvent>(onUpdateGlobalStyles,
        transformer: (events, mapper) =>
            events.debounceTime(updateDebounceTime).switchMap(mapper));
    on<ReorderSectionsEvent>(onReorderSections);
    on<ReorderWidgetEvent>(onReorderWidget);
    on<SaveLandingPageContentEvent>(_onSaveLandingPageContent);
    on<UndoPagebuilderEvent>(onUndo);
    on<RedoPagebuilderEvent>(onRedo);
    on<AddWidgetAtPositionEvent>(onAddWidgetAtPosition);
    on<AddSectionEvent>(onAddSection);
    on<AddSectionFromTemplateEvent>(onAddSectionFromTemplate);
    on<ReplacePlaceholderEvent>(onReplacePlaceholder);
    on<DeleteSectionEvent>(onDeleteSection);
    on<DuplicateSectionEvent>(onDuplicateSection);
    on<DeleteWidgetEvent>(onDeleteWidget);
    on<DuplicateWidgetEvent>(onDuplicateWidget);
  }

  bool canUndo() => localHistory.canUndo();
  bool canRedo() => localHistory.canRedo();

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

        localHistory.saveToHistory(pageBuilderContent);

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

    final contentWithoutPlaceholders =
        PagebuilderWidgetTreeManipulator.removePlaceholders(
            event.content!.content!);

    final failureOrSuccess = await pageBuilderRepo
        .saveLandingPageContent(contentWithoutPlaceholders);

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
}
