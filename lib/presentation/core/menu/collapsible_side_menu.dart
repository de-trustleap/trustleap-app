import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/core/menu/menu_toggle_button.dart';
import 'package:finanzbegleiter/presentation/core/menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollapsibleSideMenu extends StatefulWidget {
  const CollapsibleSideMenu({super.key});

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

  void hoverOnMenu(bool isHovering) => setState(() {
        menuIsHovered = isHovering;
      });

  Widget getAnimatedMenu() {
    return SizedBox(
        width: _widthAnimation.value,
        child: SideMenu(
            collapsed: collapsed,
            animationController: _animationController,
            widthAnimation: _widthAnimation));
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
        onEnter: (_) => hoverOnMenu(true),
        onExit: (_) => hoverOnMenu(false),
        child: Row(children: [
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, widget) => getAnimatedMenu()),
          Row(children: [
            if (menuIsHovered) ...[
              MenuToggleButton(
                  collapsed: collapsed,
                  animationController: _animationController,
                  toggleCollapseButtonOnTap: (isCollapsed) {
                    BlocProvider.of<MenuCubit>(context)
                        .collapseMenu(!isCollapsed);
                  })
            ],
            Container(width: 0.5, color: themeData.textTheme.bodyMedium!.color),
          ])
        ]),
      ),
    );
  }
}
