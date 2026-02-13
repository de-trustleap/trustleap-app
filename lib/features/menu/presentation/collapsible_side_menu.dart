import 'package:finanzbegleiter/features/menu/application/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/admin/presentation/admin_side_menu.dart';
import 'package:finanzbegleiter/features/menu/presentation/menu_toggle_button.dart';
import 'package:finanzbegleiter/features/menu/presentation/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollapsibleSideMenu extends StatefulWidget {
  final bool isAdmin;
  const CollapsibleSideMenu({super.key, required this.isAdmin});

  @override
  State<CollapsibleSideMenu> createState() => _CollapsibleSideMenuState();
}

class _CollapsibleSideMenuState extends State<CollapsibleSideMenu>
    with SingleTickerProviderStateMixin {
  bool collapsed = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  bool menuIsHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));

    _widthAnimation = Tween<double>(
            begin: MenuDimensions.menuOpenWidth,
            end: MenuDimensions.menuCollapsedWidth)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocListener<MenuCubit, MenuState>(
      listener: (context, state) {
        if (state is MenuIsCollapsedState) {
          setState(() {
            collapsed = state.collapsed;
            collapsed
                ? _animationController.forward()
                : _animationController.reverse();
          });
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => menuIsHovered = true),
        onExit: (_) => setState(() => menuIsHovered = false),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, theWidget) {
                return Container(
                  width: _widthAnimation.value,
                  color: themeData.colorScheme.onPrimaryContainer,
                  child: widget.isAdmin
                      ? AdminSideMenu(
                          collapsed: collapsed,
                          animationController: _animationController)
                      : SideMenu(
                          collapsed: collapsed,
                          animationController: _animationController,
                          widthAnimation: _widthAnimation),
                );
              },
            ),
            Container(
              color: themeData.colorScheme.onPrimaryContainer,
              child: Row(
                children: [
                  if (menuIsHovered)
                    MenuToggleButton(
                        collapsed: collapsed,
                        animationController: _animationController,
                        toggleCollapseButtonOnTap: (isCollapsed) {
                          BlocProvider.of<MenuCubit>(context)
                              .collapseMenu(!isCollapsed);
                        }),
                  Container(
                      width: 0.5, color: themeData.textTheme.bodyMedium!.color),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
