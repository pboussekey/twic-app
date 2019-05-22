import 'abstract_model.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:twic_app/api/models/twic_file.dart';


part 'message.g.dart';

@JsonSerializable()
class Message extends AbstractModel {
  String text;
  User user;
  DateTime createdAt;
  TwicFile attachment;

  Message({id, this.text, this.user, this.createdAt}) : super(id : id);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
