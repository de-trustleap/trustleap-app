import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/features/tremendous/application/tremendous_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TremendousConnectionWidget extends StatefulWidget {
  const TremendousConnectionWidget({super.key});

  @override
  State<TremendousConnectionWidget> createState() =>
      _TremendousConnectionWidgetState();
}

class _TremendousConnectionWidgetState
    extends State<TremendousConnectionWidget> {
  bool _isConnected = false;
  bool _isConnecting = false;
  bool _hasAttemptedConnection = false;

  @override
  void initState() {
    super.initState();
    final cubit = Modular.get<TremendousCubit>();
    cubit.startObservingConnectionStatus();
    if (cubit.state is TremendousConnectedState) {
      _isConnected = true;
    }
  }

  @override
  void dispose() {
    Modular.get<TremendousCubit>().stopObservingConnectionStatus();
    super.dispose();
  }

  void _connect() async {
    setState(() {
      _isConnecting = true;
      _hasAttemptedConnection = true;
    });
    await Modular.get<TremendousCubit>().connect();
  }

  void _disconnect() async {
    await Modular.get<TremendousCubit>().disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<TremendousCubit>();
    final snackbar = CustomSnackBar.of(context);

    return BlocListener<TremendousCubit, TremendousState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is TremendousOAuthReadyState) {
          CustomNavigator.of(context).openURLInNewTab(state.authUrl);
        } else if (state is TremendousConnectedState) {
          final wasConnecting = _isConnecting;
          setState(() {
            _isConnected = true;
            _isConnecting = false;
          });
          if (wasConnecting) {
            snackbar.showCustomSnackBar(
              localization.tremendous_success_connected,
              SnackBarType.success,
            );
          }
        } else if (state is TremendousNotConnectedState) {
          setState(() {
            _isConnected = false;
            _isConnecting = false;
          });
        } else if (state is TremendousDisconnectedState) {
          setState(() {
            _isConnected = false;
            _isConnecting = false;
          });
          snackbar.showCustomSnackBar(
            localization.tremendous_success_disconnected,
            SnackBarType.success,
          );
        } else if (state is TremendousConnectionFailureState) {
          setState(() => _isConnecting = false);
          if (_hasAttemptedConnection && !_isConnected) {
            snackbar.showCustomSnackBar(
              localization.tremendous_error_connection,
              SnackBarType.failure,
            );
          }
        } else if (state is TremendousConnectingState) {
          setState(() => _isConnecting = true);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isConnected) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                Text(
                  localization.tremendous_connected,
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondaryButton(
                  title: localization.tremendous_disconnect_button,
                  disabled: _isConnecting,
                  width: 200,
                  onTap: _disconnect,
                ),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondaryButton(
                  title: _isConnecting
                      ? localization.tremendous_connecting
                      : localization.tremendous_connect_button,
                  disabled: _isConnecting,
                  width: 200,
                  onTap: _connect,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
