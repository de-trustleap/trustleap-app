import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_fonts.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_font_family_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderGlobalStylesMenuConfig extends StatelessWidget {
  final double menuWidth;

  const PagebuilderGlobalStylesMenuConfig({
    super.key,
    required this.menuWidth,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return BlocBuilder<PagebuilderBloc, PagebuilderState>(
      bloc: Modular.get<PagebuilderBloc>(),
      builder: (context, state) {
        if (state is! GetLandingPageAndUserSuccessState) {
          return const SizedBox.shrink();
        }

        final globalStyles = state.content.content?.globalStyles;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.pagebuilder_global_colors_palette_title,
                style: themeData.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _ColorSection(
                label: localization.pagebuilder_global_colors_palette_primary,
                color: globalStyles?.colors?.primary,
                onColorChanged: (color, {token}) {
                  _updateGlobalColors(
                    context,
                    state,
                    globalStyles?.colors?.copyWith(primary: color) ??
                        PageBuilderGlobalColors(
                          primary: color,
                          secondary: null,
                          tertiary: null,
                          background: null,
                          surface: null,
                        ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ColorSection(
                label: localization.pagebuilder_global_colors_palette_secondary,
                color: globalStyles?.colors?.secondary,
                onColorChanged: (color, {token}) {
                  _updateGlobalColors(
                    context,
                    state,
                    globalStyles?.colors?.copyWith(secondary: color) ??
                        PageBuilderGlobalColors(
                          primary: null,
                          secondary: color,
                          tertiary: null,
                          background: null,
                          surface: null,
                        ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ColorSection(
                label: localization.pagebuilder_global_colors_palette_tertiary,
                color: globalStyles?.colors?.tertiary,
                onColorChanged: (color, {token}) {
                  _updateGlobalColors(
                    context,
                    state,
                    globalStyles?.colors?.copyWith(tertiary: color) ??
                        PageBuilderGlobalColors(
                          primary: null,
                          secondary: null,
                          tertiary: color,
                          background: null,
                          surface: null,
                        ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ColorSection(
                label: localization.pagebuilder_global_colors_palette_background,
                color: globalStyles?.colors?.background,
                onColorChanged: (color, {token}) {
                  _updateGlobalColors(
                    context,
                    state,
                    globalStyles?.colors?.copyWith(background: color) ??
                        PageBuilderGlobalColors(
                          primary: null,
                          secondary: null,
                          tertiary: null,
                          background: color,
                          surface: null,
                        ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ColorSection(
                label: localization.pagebuilder_global_colors_palette_surface,
                color: globalStyles?.colors?.surface,
                onColorChanged: (color, {token}) {
                  _updateGlobalColors(
                    context,
                    state,
                    globalStyles?.colors?.copyWith(surface: color) ??
                        PageBuilderGlobalColors(
                          primary: null,
                          secondary: null,
                          tertiary: null,
                          background: null,
                          surface: color,
                        ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                localization.pagebuilder_global_styles_fonts_title,
                style: themeData.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _FontSection(
                label: localization.pagebuilder_font_family_control_headline_font,
                fontFamily: globalStyles?.fonts?.headline,
                onFontChanged: (font) {
                  _updateGlobalFonts(
                    context,
                    state,
                    globalStyles?.fonts?.copyWith(headline: font) ??
                        PageBuilderGlobalFonts(headline: font, text: null),
                  );
                },
              ),
              const SizedBox(height: 12),
              _FontSection(
                label: localization.pagebuilder_font_family_control_text_font,
                fontFamily: globalStyles?.fonts?.text,
                onFontChanged: (font) {
                  _updateGlobalFonts(
                    context,
                    state,
                    globalStyles?.fonts?.copyWith(text: font) ??
                        PageBuilderGlobalFonts(
                          headline: null,
                          text: font,
                        ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateGlobalColors(
    BuildContext context,
    GetLandingPageAndUserSuccessState state,
    PageBuilderGlobalColors colors,
  ) {
    final page = state.content.content;
    if (page == null) return;

    final updatedGlobalStyles = page.globalStyles?.copyWith(
          colors: colors,
        ) ??
        PageBuilderGlobalStyles(
          colors: colors,
          fonts: null,
        );

    Modular.get<PagebuilderBloc>().add(
      UpdateGlobalStylesEvent(updatedGlobalStyles),
    );
  }

  void _updateGlobalFonts(
    BuildContext context,
    GetLandingPageAndUserSuccessState state,
    PageBuilderGlobalFonts fonts,
  ) {
    final page = state.content.content;
    if (page == null) return;

    final updatedGlobalStyles = page.globalStyles?.copyWith(
          fonts: fonts,
        ) ??
        PageBuilderGlobalStyles(
          colors: null,
          fonts: fonts,
        );

    Modular.get<PagebuilderBloc>().add(
      UpdateGlobalStylesEvent(updatedGlobalStyles),
    );
  }
}

class _ColorSection extends StatelessWidget {
  final String label;
  final Color? color;
  final Function(Color, {String? token}) onColorChanged;

  const _ColorSection({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PagebuilderColorControl(
      title: label,
      initialColor: color ?? Colors.transparent,
      onColorSelected: onColorChanged,
      enableGradients: false,
    );
  }
}

class _FontSection extends StatelessWidget {
  final String label;
  final String? fontFamily;
  final Function(String) onFontChanged;

  const _FontSection({
    required this.label,
    required this.fontFamily,
    required this.onFontChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PagebuilderFontFamilyControl(
      initialValue: fontFamily ?? "Poppins",
      onSelected: onFontChanged,
      label: label,
    );
  }
}
