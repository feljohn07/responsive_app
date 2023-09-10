import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/event_list/models/event.dart';
import 'package:responsive_app/event_list/view_models/events_view_model.dart';

class EditEventView extends StatefulWidget {
  const EditEventView({super.key});
  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    EventViewModel eventViewModel = context.watch<EventViewModel>();
    Event? editEvent = eventViewModel.selectedEvent;
    print(editEvent!.id);

    TextEditingController eventController =
        TextEditingController(text: editEvent.name);
    TextEditingController descriptionController =
        TextEditingController(text: editEvent.description);
    TextEditingController locationController =
        TextEditingController(text: editEvent.location);
    TextEditingController dateController =
        TextEditingController(text: editEvent.date.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        actions: [
          IconButton(
              onPressed: () {
                eventViewModel.editEvent();
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
                controller: eventController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event name required.';
                  }
                  return null;
                },
                onChanged: (value) {
                  editEvent.name = value;
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
                controller: descriptionController,
                onChanged: (value) {
                  editEvent.description = value;
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
                  editEvent.location = value;
                },
                controller: locationController,
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

                      // editEvent?.date = value;
                      dateController.text = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              timeOfDay.hour,
                              timeOfDay.minute)
                          .toString();

                      editEvent.date = DateTime(dateTime.year, dateTime.month,
                          dateTime.day, timeOfDay.hour, timeOfDay.minute);
                    });
                  });
                },
                onChanged: (value) {
                  editEvent.date = DateTime.parse(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
