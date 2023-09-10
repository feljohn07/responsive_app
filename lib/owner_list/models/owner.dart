import 'package:objectbox/objectbox.dart';

@Entity()
class Owner {
  @Id()
  int id;
  String name;

  Owner(this.name, {this.id = 0});
}