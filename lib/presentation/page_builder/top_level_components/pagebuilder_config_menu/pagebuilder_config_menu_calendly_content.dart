import 'package:finanzbegleiter/application/calendly/calendly_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuCalendlyContent extends StatefulWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuCalendlyContent({super.key, required this.model});

  @override
  State<PagebuilderConfigMenuCalendlyContent> createState() => _PagebuilderConfigMenuCalendlyContentState();
}

class _PagebuilderConfigMenuCalendlyContentState extends State<PagebuilderConfigMenuCalendlyContent> {
  late CalendlyCubit calendlyCubit;

  @override
  void initState() {
    super.initState();
    calendlyCubit = Modular.get<CalendlyCubit>();
    calendlyCubit.startObservingAuthStatus();
  }

  @override
  void dispose() {
    calendlyCubit.stopObservingAuthStatus();
    super.dispose();
  }

  void updateCalendlyProperties(
      PagebuilderCalendlyProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = widget.model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();
    final properties = widget.model.properties as PagebuilderCalendlyProperties;

    return CollapsibleTile(
      title: "Calendly Event Auswahl",
      children: [
        BlocBuilder<CalendlyCubit, CalendlyState>(
          bloc: calendlyCubit,
          builder: (context, calendlyState) {
            if (calendlyState is CalendlyConnectedState) {
              return _buildEventTypeDropdown(
                calendlyState.eventTypes, 
                properties, 
                pagebuilderCubit,
              );
            } else if (calendlyState is CalendlyAuthenticatedState) {
              return Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  const Text("Event Types werden geladen..."),
                ],
              );
            } else if (calendlyState is CalendlyNotAuthenticatedState) {
              return _buildLoginButton(calendlyCubit);
            } else if (calendlyState is CalendlyConnectingState) {
              return Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  const Text("Verbindung wird hergestellt..."),
                ],
              );
            } else if (calendlyState is CalendlyConnectionFailureState) {
              return Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text("Fehler: ${calendlyState.failure.toString()}"),
                  const SizedBox(height: 8),
                  _buildLoginButton(calendlyCubit),
                ],
              );
            } else {
              return _buildLoginButton(calendlyCubit);
            }
          },
        ),
      ],
    );
  }

  Widget _buildEventTypeDropdown(
    List<Map<String, dynamic>> eventTypes,
    PagebuilderCalendlyProperties properties,
    PagebuilderBloc pagebuilderCubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Event Type auswählen:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: properties.calendlyEventUrl,
          hint: const Text("Event Type wählen..."),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: eventTypes.map<DropdownMenuItem<String>>((eventType) {
            final name = eventType['name'] as String? ?? 'Unnamed Event';
            final url = eventType['scheduling_url'] as String? ?? '';
            return DropdownMenuItem<String>(
              value: url,
              child: Text(name),
            );
          }).toList(),
          onChanged: (selectedUrl) {
            if (selectedUrl != null) {
              final selectedEventType = eventTypes.firstWhere(
                (eventType) => eventType['scheduling_url'] == selectedUrl,
              );
              final eventTypeName = selectedEventType['name'] as String? ?? '';
              
              updateCalendlyProperties(
                properties.copyWith(
                  calendlyEventUrl: selectedUrl,
                  eventTypeName: eventTypeName,
                ),
                pagebuilderCubit,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(CalendlyCubit calendlyCubit) {
    return Column(
      children: [
        const Icon(Icons.calendar_today, size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        const Text(
          "Calendly Verbindung erforderlich",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Um Event Types auszuwählen, müssen Sie sich zuerst mit Calendly verbinden.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => calendlyCubit.connectToCalendly(),
          icon: const Icon(Icons.link),
          label: const Text("Mit Calendly verbinden"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}