import 'abstract_model.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:json_annotation/json_annotation.dart';


part 'hashtag.g.dart';

@JsonSerializable()
class Hashtag extends AbstractModel {
  String name;
  @JsonKey(defaultValue : 0)
  int nbFollowers;
  @JsonKey(defaultValue : false)
  bool followed;
  TwicFile picture;

  Hashtag({id, this.name, this.nbFollowers, this.followed, this.picture}) : super(id : id);

  factory Hashtag.fromJson(Map<String, dynamic> json) => _$HashtagFromJson(json);
  Map<String, dynamic> toJson() => _$HashtagToJson(this);

}
