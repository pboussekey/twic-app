import 'abstract_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'field.g.dart';

@JsonSerializable()
class Field extends AbstractModel {
  String name;

  Field({id, this.name}) : super(id : id);

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
  Map<String, dynamic> toJson() => _$FieldToJson(this);

}
