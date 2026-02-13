import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_zoom/pagebuilder_zoom_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_content.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/utils/keyboard_shortcut_helper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/widgets/pagebuilder_appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final PagebuilderContent content;
  final bool isLoading;
  final bool isHierarchyOpen;
  final bool isResponsivePreviewOpen;
  final VoidCallback onHierarchyToggle;
  final VoidCallback onResponsivePreviewToggle;
  final dividerHeight = 0.5;

  const LandingPageBuilderAppBar({
    super.key,
    required this.content,
    required this.isLoading,
    required this.isHierarchyOpen,
    required this.isResponsivePreviewOpen,
    required this.onHierarchyToggle,
    required this.onResponsivePreviewToggle,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final zoomCubit = Modular.get<PagebuilderZoomCubit>();

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + dividerHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text(
              content.landingPage?.name ?? "",
              style: themeData.textTheme.bodyLarge,
            ),
            centerTitle: true,
            leading: BlocBuilder<PagebuilderConfigMenuCubit,
                PagebuilderConfigMenuState>(
              bloc: Modular.get<PagebuilderConfigMenuCubit>(),
              builder: (context, state) {
                final isMenuOpen = state is! PageBuilderConfigMenuClosedState;
                return PagebuilderAppbarButton(
                  icon: isMenuOpen ? Icons.menu_open : Icons.menu,
                  tooltip: isMenuOpen
                      ? localization.pagebuilder_config_menu_close_tooltip
                      : localization.pagebuilder_config_menu_open_tooltip,
                  onPressed: () {
                    Modular.get<PagebuilderConfigMenuCubit>()
                        .toggleConfigMenu();
                  },
                );
              },
            ),
            actions: [
              BlocBuilder<PagebuilderBloc, PagebuilderState>(
                bloc: Modular.get<PagebuilderBloc>(),
                builder: (context, state) {
                  final bloc = Modular.get<PagebuilderBloc>();
                  return Row(
                    children: [
                      Tooltip(
                        message: "${localization.pagebuilder_undo_tooltip} (${KeyboardShortcutHelper.getUndoShortcut()})",
                        child: IconButton(
                          icon: Icon(
                            Icons.undo,
                            color: bloc.canUndo()
                                ? themeData.colorScheme.secondary
                                : null,
                          ),
                          onPressed: bloc.canUndo()
                              ? () => bloc.add(UndoPagebuilderEvent())
                              : null,
                        ),
                      ),
                      Tooltip(
                        message: "${localization.pagebuilder_redo_tooltip} (${KeyboardShortcutHelper.getRedoShortcut()})",
                        child: IconButton(
                          icon: Icon(
                            Icons.redo,
                            color: bloc.canRedo()
                                ? themeData.colorScheme.secondary
                                : null,
                          ),
                          onPressed: bloc.canRedo()
                              ? () => bloc.add(RedoPagebuilderEvent())
                              : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: BlocBuilder<PagebuilderZoomCubit, PagebuilderZoomLevel>(
                  bloc: zoomCubit,
                  builder: (context, zoomLevel) {
                    return UnderlinedDropdown<PagebuilderZoomLevel>(
                      value: zoomLevel,
                      items: PagebuilderZoomLevel.values
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level.label),
                              ))
                          .toList(),
                      onChanged: (newLevel) {
                        if (newLevel != null) {
                          Modular.get<PagebuilderZoomCubit>()
                              .setZoomLevel(newLevel);
                        }
                      },
                    );
                  },
                ),
              ),
              PagebuilderAppbarButton(
                icon: Icons.devices,
                tooltip: isResponsivePreviewOpen
                    ? localization.pagebuilder_responsive_preview_close_tooltip
                    : localization.pagebuilder_responsive_preview_button_tooltip,
                onPressed: onResponsivePreviewToggle,
              ),
              PagebuilderAppbarButton(
                icon: Icons.account_tree,
                tooltip: isHierarchyOpen
                    ? localization.pagebuilder_hierarchy_close_tooltip
                    : localization.pagebuilder_hierarchy_button_tooltip,
                onPressed: onHierarchyToggle,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: PrimaryButton(
                  title: localization
                      .landingpage_pagebuilder_appbar_save_button_title,
                  isLoading: isLoading,
                  disabled: isLoading,
                  width: 180,
                  onTap: () {
                    Modular.get<PagebuilderBloc>()
                        .add(SaveLandingPageContentEvent(content));
                  },
                ),
              )
            ],
          ),
          Divider(
            color: themeData.textTheme.bodyMedium!.color,
            height: dividerHeight,
            thickness: dividerHeight,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + dividerHeight);
}
