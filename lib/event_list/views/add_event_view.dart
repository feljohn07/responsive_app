import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/event_list/models/event.dart';
import 'package:responsive_app/event_list/view_models/events_view_model.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});
  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    EventViewModel eventViewModel = context.watch<EventViewModel>();
    Event? addEvent = eventViewModel.addingEvent;

    TextEditingController dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
        actions: [
          IconButton(
              onPressed: () async {
                await eventViewModel.addEvent();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.event_note),
                  border: OutlineInputBorder(),
                  labelText: 'Event name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event name required.';
                  }
                  return null;
                },
                onChanged: (value) {
                  addEvent?.name = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  labelText: 'Event Description',
                ),
                onChanged: (value) {
                  addEvent?.description = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                  labelText: 'Event Location',
                ),
                onChanged: (value) {
                  addEvent?.location = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  labelText: 'Event Date',
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    dateController.text = value.toString();
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((time) {
                      DateTime dateTime = DateTime.parse(dateController.text);
                      print(' here $time');
                      TimeOfDay timeOfDay = time!;

                      // addEvent?.date = value;
                      dateController.text = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              timeOfDay.hour,
                              timeOfDay.minute)
                          .toString();

                      addEvent?.date = DateTime(dateTime.year, dateTime.month,
                          dateTime.day, timeOfDay.hour, timeOfDay.minute);
                    });
                  });
                },
                onChanged: (value) {
                  addEvent?.date = DateTime.parse(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
