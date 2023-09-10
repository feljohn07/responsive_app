import 'package:flutter/material.dart';
import 'package:responsive_app/owner_list/models/owner.dart';
import 'package:responsive_app/task_list/models/task.dart';

import '../../objectbox.g.dart';
import '../models/event.dart';

import 'object_box_view_model.dart';

class EventViewModel extends ChangeNotifier {
  String _searchQuery = '';
  Event? _selectedEvent;
  // ignore: prefer_final_fields
  Event _addingEvent = Event('');
  int _eventCount = 0;

  String get searchQuery => _searchQuery;
  Event? get selectedEvent => _selectedEvent;
  Event? get addingEvent => _addingEvent;
  int get eventCount => _eventCount;

  setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  setSelectedEvent(Event event) {
    _selectedEvent = event;
    print(_selectedEvent!.toJson());
    notifyListeners();
  }

  addEvent() {
    Event newEvent = addingEvent!;
    objectbox.eventBox.put(newEvent, mode: PutMode.insert);
    _addingEvent = Event('');
    setEventCount();
  }

  editEvent() {
    objectbox.eventBox.put(_selectedEvent!, mode: PutMode.update);
    notifyListeners();
  }

  deleteEvent(int id) {
    objectbox.eventBox.remove(id);
    setEventCount();
  }

  setEventCount() {
    _eventCount = objectbox.eventBox.count();
    return objectbox.eventBox.count();
  }

  Stream<List<Event>> searchEvents() {
    final builder = objectbox.eventBox
        .query(Event_.description.contains(searchQuery, caseSensitive: false))
      ..order(Event_.id, flags: Order.descending);

    setEventCount();

    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Stream<List<Owner>> getOwners() {
    final builder = objectbox.ownerBox.query()
      ..order(Owner_.id, flags: Order.descending);

    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

}

