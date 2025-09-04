import 'package:finanzbegleiter/application/calendly/calendly_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CalendlyConnectionWidget extends StatefulWidget {
  final bool isRequired;
  final String? selectedEventTypeUrl;
  final Function(String?)? onEventTypeSelected;
  final bool showEventTypes;
  final bool showDisconnectButton;
  final Function(bool)? onConnectionStatusChanged;

  const CalendlyConnectionWidget({
    super.key,
    required this.isRequired,
    required this.selectedEventTypeUrl,
    this.onEventTypeSelected,
    this.showEventTypes = true,
    this.showDisconnectButton = false,
    this.onConnectionStatusChanged,
  });

  @override
  State<CalendlyConnectionWidget> createState() =>
      _CalendlyConnectionWidgetState();
}

class _CalendlyConnectionWidgetState extends State<CalendlyConnectionWidget> {
  bool isCalendlyConnected = false;
  bool isConnectingCalendly = false;
  bool isLoadingEventTypes = false;
  List<Map<String, dynamic>> eventTypes = [];

  @override
  void initState() {
    super.initState();
    _initializeCalendlyState();
    final calendlyCubit = Modular.get<CalendlyCubit>();
    calendlyCubit.startObservingAuthStatus();
  }

  void _initializeCalendlyState() {
    final calendlyCubit = Modular.get<CalendlyCubit>();
    final currentState = calendlyCubit.state;

    if (currentState is CalendlyConnectedState) {
      setState(() {
        isCalendlyConnected = true;
        eventTypes = currentState.eventTypes;
        isLoadingEventTypes = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onConnectionStatusChanged?.call(true);
      });
    } else if (currentState is CalendlyAuthenticatedState) {
      setState(() {
        isCalendlyConnected = true;
        eventTypes = [];
        isLoadingEventTypes = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onConnectionStatusChanged?.call(true);
      });
    }
  }

  @override
  void dispose() {
    final calendlyCubit = Modular.get<CalendlyCubit>();
    calendlyCubit.stopObservingAuthStatus();
    super.dispose();
  }

  void _connectCalendly() async {
    final calendlyCubit = Modular.get<CalendlyCubit>();

    setState(() {
      isConnectingCalendly = true;
    });

    await calendlyCubit.connectToCalendly();

    setState(() {
      isConnectingCalendly = false;
    });
  }

  void _disconnectCalendly() async {
    final calendlyCubit = Modular.get<CalendlyCubit>();
    await calendlyCubit.disconnect();
  }

  String? _getValidInitialSelection() {
    if (eventTypes.isEmpty) return null;

    if (widget.selectedEventTypeUrl == null ||
        widget.selectedEventTypeUrl!.isEmpty) {
      return null;
    }

    final hasValidSelection = eventTypes.any((eventType) =>
        eventType['scheduling_url'] == widget.selectedEventTypeUrl);
    return hasValidSelection ? widget.selectedEventTypeUrl : null;
  }

  List<DropdownMenuEntry<String>> _buildDropdownEntries() {
    return eventTypes.map<DropdownMenuEntry<String>>((eventType) {
      final name = eventType['name'] as String? ?? 'Unbekannt';
      final schedulingUrl = eventType['scheduling_url'] as String? ?? '';
      return DropdownMenuEntry<String>(
        value: schedulingUrl,
        label: name,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final calendlyCubit = Modular.get<CalendlyCubit>();
    final customSnackbar = CustomSnackBar.of(context);

    return BlocListener<CalendlyCubit, CalendlyState>(
      bloc: calendlyCubit,
      listener: (context, state) {
        if (state is CalendlyOAuthReadyState) {
          final navigator = CustomNavigator.of(context);
          navigator.openURLInNewTab(state.authUrl);
        } else if (state is CalendlyConnectedState) {
          final wasConnecting = isConnectingCalendly;
          setState(() {
            isCalendlyConnected = true;
            isConnectingCalendly = false;
            eventTypes = state.eventTypes;
            isLoadingEventTypes = false;
          });
          widget.onConnectionStatusChanged?.call(true);
          if (wasConnecting) {
            customSnackbar.showCustomSnackBar(
              localization.calendly_success_connected,
              SnackBarType.success,
            );
          }
        } else if (state is CalendlyAuthenticatedState) {
          setState(() {
            isCalendlyConnected = true;
            isConnectingCalendly = false;
            eventTypes = [];
            isLoadingEventTypes = true;
          });
          widget.onConnectionStatusChanged?.call(true);
        } else if (state is CalendlyNotAuthenticatedState) {
          setState(() {
            isCalendlyConnected = false;
            isConnectingCalendly = false;
            eventTypes = [];
            widget.onEventTypeSelected?.call(null);
            isLoadingEventTypes = false;
          });
          widget.onConnectionStatusChanged?.call(false);
        } else if (state is CalendlyConnectionFailureState) {
          final wasConnecting = isConnectingCalendly;
          setState(() {
            isConnectingCalendly = false;
            if (isCalendlyConnected) {
              isLoadingEventTypes = false;
            }
          });
          if (wasConnecting && !isCalendlyConnected) {
            customSnackbar.showCustomSnackBar(
              localization.calendly_error_connection,
              SnackBarType.failure,
            );
          }
        } else if (state is CalendlyDisconnectedState) {
          setState(() {
            isCalendlyConnected = false;
            isConnectingCalendly = false;
            eventTypes = [];
            widget.onEventTypeSelected?.call(null);
            isLoadingEventTypes = false;
          });
          widget.onConnectionStatusChanged?.call(false);
          customSnackbar.showCustomSnackBar(
            localization.calendly_success_disconnected,
            SnackBarType.success,
          );
        } else if (state is CalendlyConnectingState) {
          setState(() {
            isConnectingCalendly = true;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isCalendlyConnected) ...[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localization.landingpage_creator_calendly_connected,
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (widget.showDisconnectButton) ...[
                  const SizedBox(height: 16),
                  SecondaryButton(
                    title: localization
                        .landingpage_creator_calendly_disconnect_button,
                    disabled: isConnectingCalendly,
                    isLoading: isConnectingCalendly,
                    width: 200,
                    onTap: _disconnectCalendly,
                  ),
                ],
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondaryButton(
                  title: isConnectingCalendly
                      ? localization.landingpage_creator_calendly_connecting
                      : localization
                          .landingpage_creator_calendly_connect_button,
                  disabled: isConnectingCalendly,
                  width: 200,
                  onTap: _connectCalendly,
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (widget.showEventTypes && eventTypes.isNotEmpty) ...[
            FormField<String>(
              validator: (value) {
                if (widget.isRequired && widget.selectedEventTypeUrl == null) {
                  return localization
                      .landingpage_creator_calendly_event_type_validation;
                }
                return null;
              },
              builder: (FormFieldState<String> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownMenu<String>(
                      width: double.infinity,
                      label: Text(localization
                          .landingpage_creator_calendly_event_type_select),
                      initialSelection: _getValidInitialSelection(),
                      enableSearch: false,
                      requestFocusOnTap: false,
                      dropdownMenuEntries: _buildDropdownEntries(),
                      onSelected: (String? newValue) {
                        widget.onEventTypeSelected?.call(newValue);
                        state.didChange(newValue);
                      },
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                        child: Text(
                          state.errorText!,
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: themeData.colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ] else if (widget.showEventTypes && isCalendlyConnected) ...[
            Text(
              isLoadingEventTypes
                  ? localization
                      .landingpage_creator_calendly_event_types_loading
                  : localization.landingpage_creator_calendly_event_types_empty,
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: isLoadingEventTypes ? null : themeData.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
