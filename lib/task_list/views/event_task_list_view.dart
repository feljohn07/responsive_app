import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/task_list/components/task_list_item.dart';
import 'package:responsive_app/task_list/models/task.dart';
import 'package:responsive_app/event_list/view_models/events_view_model.dart';
import 'package:responsive_app/task_list/view_models/task_view_model.dart';
import 'package:responsive_app/utils/navigation_utils.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    TaskViewModel taskViewModel = context.watch();
    EventViewModel eventViewModel = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: Text(eventViewModel.selectedEvent!.name),
        actions: [
          IconButton(
              onPressed: () {
                openEventEditView(context);
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: StreamBuilder<List<Task>>(
          stream: taskViewModel.getTasks(eventViewModel.selectedEvent!),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                itemBuilder: (context, index) {
                  return TaskListItem(
                    task: snapshot.data![index],
                    onTap: () {},
                    onTapDelete: (Task task) {
                      taskViewModel.deleteTask(task.id);
                    },
                    onToggle: (bool? value) {
                      print(value);
                      taskViewModel.toggleTaskStatus(snapshot.data![index]);
                    }, 
                  );
                },
              );
            } else {
              return const Center(
                  child: Text('Press the + icon to add an event'));
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            opentAddTaskView(context);
          },
          label: const Row(
            children: [Icon(Icons.add), Text('New Task')],
          )),
    );
  }
}
