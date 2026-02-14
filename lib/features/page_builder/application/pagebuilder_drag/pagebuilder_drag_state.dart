part of 'pagebuilder_drag_cubit.dart';

class PagebuilderDragCubitState with EquatableMixin {
  final bool isDragging;
  final String? activeContainerId;
  final GlobalKey? activeContainerKey;
  final String? libraryDragTargetContainerId;
  final GlobalKey? libraryDragTargetContainerKey;

  const PagebuilderDragCubitState({
    required this.isDragging,
    this.activeContainerId,
    this.activeContainerKey,
    this.libraryDragTargetContainerId,
    this.libraryDragTargetContainerKey,
  });

  PagebuilderDragCubitState copyWith({
    bool? isDragging,
    String? activeContainerId,
    GlobalKey? activeContainerKey,
    String? libraryDragTargetContainerId,
    GlobalKey? libraryDragTargetContainerKey,
    bool clearActiveContainer = false,
    bool clearLibraryDragTarget = false,
  }) {
    return PagebuilderDragCubitState(
      isDragging: isDragging ?? this.isDragging,
      activeContainerId: clearActiveContainer
          ? null
          : (activeContainerId ?? this.activeContainerId),
      activeContainerKey: clearActiveContainer
          ? null
          : (activeContainerKey ?? this.activeContainerKey),
      libraryDragTargetContainerId: clearLibraryDragTarget
          ? null
          : (libraryDragTargetContainerId ?? this.libraryDragTargetContainerId),
      libraryDragTargetContainerKey: clearLibraryDragTarget
          ? null
          : (libraryDragTargetContainerKey ??
              this.libraryDragTargetContainerKey),
    );
  }

  @override
  List<Object?> get props => [
        isDragging,
        activeContainerId,
        activeContainerKey,
        libraryDragTargetContainerId,
        libraryDragTargetContainerKey,
      ];
}
