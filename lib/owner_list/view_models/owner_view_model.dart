import 'package:flutter/material.dart';
import 'package:responsive_app/owner_list/models/owner.dart';
import 'package:responsive_app/task_list/models/task.dart';
import 'package:responsive_app/event_list/models/event.dart';

import '../../objectbox.g.dart';
import '../../event_list/view_models/object_box_view_model.dart';

class OwnerViewModel extends ChangeNotifier {

  Owner _selectedOwner = Owner('');
  // ignore: prefer_final_fields
  late Owner _addingOwner;

  Owner? get addingOwner => _addingOwner;
  Owner? get selectedOwner => _selectedOwner;

  void setSelectedOwner (Owner owner) {
    _selectedOwner = owner;
    notifyListeners();
  }

  // void addOwner(Event event, Owner owner) {

  //   Task newTask = Task(_addingOwner.name);
  //   newTask.owner.target = owner;

  //   Event updatedEvent = event;
  //   updatedEvent.tasks.add(newTask);
  //   newTask.event.target = updatedEvent;

  //   objectbox.eventBox.put(updatedEvent);

  //   debugPrint(
  //       'Added Task: ${newTask.text} assigned to ${newTask.owner.target?.name} in event: ${updatedEvent.name}');
  // }

  Stream<List<Owner>> getOwners() {
    final builder = objectbox.ownerBox.query()
      ..order(Owner_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}
