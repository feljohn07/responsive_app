import 'package:objectbox/objectbox.dart';
import '../../event_list/models/event.dart';
import '../../owner_list/models/owner.dart';


@Entity()
class Task {
  @Id()
  int id;
  String text;
  bool status;

  Task(this.text, {this.id = 0, this.status = false});

  // To-one relation to a Owner Object.
  // https://docs.objectbox.io/relations#to-one-relations
  final owner = ToOne<Owner>();

  final event = ToOne<Event>();

  bool setFinished() {
    status = !status;
    return status;
  }
}