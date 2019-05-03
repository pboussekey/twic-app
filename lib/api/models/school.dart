import 'abstract_model.dart';
import 'package:twic_app/api/models/twic_file.dart';

class School extends AbstractModel {
  int id;
  String name;
  TwicFile logo;
  School university;

  School.fromJson(Map<String, dynamic> data) {
    id = data['id'] is int ? data['id'] : int.parse(data['id']);
    name = data['name'];
    if (null != data['logo']) {
      logo = TwicFile.fromJson(data['logo']);
    }
    if (null != data['university']) {
      university = School.fromJson(data['university']);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo': null != logo ? logo.toJson() : null,
        'university': null != university ? university.toJson() : null
      };
}
