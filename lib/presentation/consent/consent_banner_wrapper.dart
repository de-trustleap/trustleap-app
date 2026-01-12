import 'package:finanzbegleiter/application/consent/consent_cubit.dart';
import 'package:finanzbegleiter/presentation/consent/cookie_consent_banner.dart';
import 'package:finanzbegleiter/presentation/consent/cookie_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ConsentBannerWrapper extends StatefulWidget {
  final Widget child;

  const ConsentBannerWrapper({super.key, required this.child});

  @override
  State<ConsentBannerWrapper> createState() => _ConsentBannerWrapperState();
}

class _ConsentBannerWrapperState extends State<ConsentBannerWrapper> {
  bool _showDialog = false;

  void _onCustomizePressed() {
    setState(() {
      _showDialog = true;
    });
  }

  void _onCloseDialog() {
    setState(() {
      _showDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final consentCubit = Modular.get<ConsentCubit>()..checkConsentStatus();

    return BlocBuilder<ConsentCubit, ConsentState>(
      bloc: consentCubit,
      builder: (context, consentState) {
        final shouldShowBanner = consentState is ConsentRequiredState;

        return Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: shouldShowBanner
                    ? Material(
                        key: const ValueKey('consent-banner'),
                        color: Colors.black.withValues(alpha: 0.5),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CookieConsentBanner(
                                onCustomizePressed: _onCustomizePressed,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.expand(
                        key: ValueKey('no-banner'),
                      ),
              ),
            ),
            if (_showDialog)
              Positioned.fill(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: CookieSettingsDialog(
                        onClose: _onCloseDialog,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
