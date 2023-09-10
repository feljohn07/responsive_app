import 'package:flutter/material.dart';
import 'package:responsive_app/task_list/models/task.dart';
import 'package:responsive_app/owner_list/models/owner.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function onToggle;
  final Function onTap;
  final Function onTapDelete;

  const TaskListItem(
      {super.key,
      required this.task,
      required this.onTap,
      required this.onTapDelete,
      required this.onToggle});

  @override
  Widget build(BuildContext context) {
    Owner? owner = task.owner.target;

    return InkWell(
      onTap: () => onTap(),
      child: Row(children: [
        Expanded(
          child: ListTile(
            leading: Transform.scale(
              scale: 1.3,
              child: Checkbox(
                shape: const CircleBorder(),
                value: task.status,
                onChanged: (bool? value) => onToggle(value),
              ),
            ),
            title: Text('${task.id} ${task.text}'),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Owner: ${owner!.name}'),
              Text(task.status.toString()),
            ]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onTapDelete(task),
            ),
          ),
        ),
      ]),
    );
  }
}
