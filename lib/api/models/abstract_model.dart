import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class AbstractModel extends Equatable {
  static int parseId(id) => id is String ? int.parse(id) : id;
  @JsonKey(fromJson: parseId)
  int id;

  AbstractModel({this.id}){
    this.id = id;
  }

  AbstractModel.fromJson(Map<String, dynamic> data);


  @override
  bool operator ==(Object other) => other is AbstractModel && id == other.id;
}
