import 'package:twic_app/api/models/user.dart';
import 'abstract_model.dart';
import 'twic_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends AbstractModel {
  String content;
  String privacy;
  DateTime createdAt;
  int nbComments;
  int nbLikes;
  @JsonKey(fromJson: AbstractModel.parseBool)
  bool isLiked;
  User user;
  List<TwicFile> files = [];

  Post(
      {id,
      this.content,
      this.privacy,
      this.files,
      this.createdAt,
      this.nbLikes,
      this.user,
      this.isLiked,
      this.nbComments}) : super(id : id);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
