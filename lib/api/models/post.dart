import 'package:twic_app/api/models/user.dart';
import 'abstract_model.dart';
import 'twic_file.dart';
import 'hashtag.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends AbstractModel {
  String content;
  String privacy;
  DateTime createdAt;
  int nbComments;
  int nbLikes;
  bool isLiked;
  User user;
  List<TwicFile> files = [];
  List<Hashtag> hashtags = [];

  Post(
      {id,
      this.content,
      this.privacy = "PUBLIC",
      this.files,
      this.createdAt,
      this.nbLikes = 0,
      this.user,
      this.isLiked = false,
      this.nbComments = 0}) : super(id : id);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
