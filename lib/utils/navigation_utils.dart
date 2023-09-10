import 'package:flutter/material.dart';
import 'package:responsive_app/users_list/views/add_user_screen.dart';
import 'package:responsive_app/users_list/views/user_details_page.dart';

import 'package:responsive_app/task_list/views/add_task_view.dart';
import 'package:responsive_app/event_list/views/edit_event_view.dart';
import 'package:responsive_app/task_list/views/event_task_list_view.dart';
import 'package:responsive_app/event_list/views/add_event_view.dart';

void openUserDetails(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserDetailsScreen(),
    ),
  );
}

void openAddUser(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddUserScreen(),
    ),
  );
}


void opentAddEventView(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddEventView(),
    ),
  );
}

void openEventEditView(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const EditEventView(),
    ),
  );
}

void opentTaskListView(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TaskListView(),
    ),
  );
}

void opentAddTaskView(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddTaskView(),
    ),
  );
}


// void openAddUser(BuildContext context) async {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => AddUserScreen(),
//     ),
//   );
// }

