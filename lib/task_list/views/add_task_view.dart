import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/event_list/models/event.dart';
import '/owner_list/models/owner.dart';
import '/task_list/models/task.dart';
import '/event_list/view_models/events_view_model.dart';
import '/owner_list/view_models/owner_view_model.dart';
import '/task_list/view_models/task_view_model.dart';
import '/utils/snackbar.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TaskViewModel taskViewModel = context.watch<TaskViewModel>();
    EventViewModel eventViewModel = context.watch<EventViewModel>();
    OwnerViewModel ownerViewModel = context.watch<OwnerViewModel>();
    Task? addTask = taskViewModel.addingTask;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        actions: [
          IconButton(
              onPressed: () async {
                taskViewModel.addTask(eventViewModel.selectedEvent!,
                    ownerViewModel.selectedOwner!);
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.task),
                    border: OutlineInputBorder(),
                    labelText: 'Task note',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Task note required.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    addTask?.text = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<List<Owner>>(
                  stream: ownerViewModel.getOwners(),
                  builder: (context, snapshot) {
                    return DropdownButtonFormField(
                      
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        labelText: 'Owner',
                      ),
                      alignment: AlignmentDirectional.bottomCenter,
                      // hint: Padding(
                      //   padding: const EdgeInsets.only(left: 20.0),
                      //   child: Text(ownerViewModel.selectedOwner!.name,
                      //       style: const TextStyle(color: Colors.black)),
                      // ),
                      icon: (ownerViewModel.selectedOwner != null) ? InkWell(
                        child: const Icon(Icons.add_outlined),
                        onTap: () {
                          showSnackBar(context, 'Add new owner.');
                        },
                      ) : null,
                      items: snapshot.data!.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                          onTap: () {
                            ownerViewModel.setSelectedOwner(value);
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
