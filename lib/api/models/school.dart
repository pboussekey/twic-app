import 'abstract_model.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:json_annotation/json_annotation.dart';


part 'school.g.dart';

@JsonSerializable()
class School extends AbstractModel {
  String name;
  TwicFile logo;

  School({id, this.name,  this.logo}) : super(id : id);


  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);
  Map<String, dynamic> toJson() => _$SchoolToJson(this);
}
