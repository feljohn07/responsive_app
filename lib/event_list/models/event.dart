import 'package:objectbox/objectbox.dart';
import '../../task_list/models/task.dart';

@Entity()
class Event {
  @Id()
  int id;
  String name;
  String? description;
  String? location;
  
  @Property(type: PropertyType.date)
  DateTime? date;

  Event(this.name, {this.id = 0, this.description, this.date, this.location});

  @Backlink('event')
  final tasks = ToMany<Task>();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'location': location,
    'date': date,
  };
}
