import 'abstract_model.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:twic_app/api/models/twic_file.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation extends AbstractModel {


  String name;
  String last;
  List<User> users = [];
  DateTime lastDate;
  TwicFile picture;

  Conversation({id, this.name, this.last, this.lastDate, this.users}) : super(id : id);

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
