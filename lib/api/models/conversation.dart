import 'abstract_model.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:twic_app/api/models/hashtag.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation extends AbstractModel {
  String name;
  String last;
  List<User> users = [];
  DateTime lastDate;
  TwicFile picture;
  Hashtag hashtag;
  String type;
  @JsonKey(fromJson: AbstractModel.parseId)
  int lastId;
  @JsonKey(defaultValue : 0)
  int unread = 0;

  Conversation(
      {id,
      this.name,
      this.last,
      this.lastDate,
      this.users,
      this.hashtag,
      this.unread})
      : super(id: id);

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
