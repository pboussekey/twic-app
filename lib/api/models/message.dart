import 'abstract_model.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:twic_app/api/models/twic_file.dart';


part 'message.g.dart';

@JsonSerializable()
class Message extends AbstractModel {
  String text;
  String type;
  User user;
  DateTime createdAt;
  TwicFile attachment;
  @JsonKey(fromJson: AbstractModel.parseId)
  int conversation_id;

  Message({id, this.text, this.user, this.createdAt}) : super(id : id);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
