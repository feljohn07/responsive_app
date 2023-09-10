import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/event_list/view_models/events_view_model.dart';
import 'package:responsive_app/event_list/views/event_list_view.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    EventViewModel eventViewModel = context.watch<EventViewModel>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              labelText: 'Search',
            ),
            onChanged: (text) {
              setState(() {
                eventViewModel.setSearchQuery(text);
              });
            },
            onSubmitted: (value) {
              setState(() {
                eventViewModel.setSearchQuery(value);
              });
            },
          ),
          const Expanded(child: EventList()),
        ],
      ),
    );
  }
}
