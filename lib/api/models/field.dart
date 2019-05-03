import 'abstract_model.dart';

class Field extends AbstractModel {
  int id;
  String name;

  Field.fromJson(Map<String, dynamic> data) {
    id = data['id'] is int ? data['id'] : int.parse(data['id']);
    name = data['name'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
