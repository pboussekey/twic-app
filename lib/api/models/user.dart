import 'package:twic_app/api/models/school.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:twic_app/api/models/field.dart';
import 'package:json_annotation/json_annotation.dart';

import 'abstract_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends AbstractModel {
  String firstname;
  String lastname;
  String description;
  TwicFile avatar;
  School school;
  Field major;
  Field minor;
  bool isActive;
  int classYear;
  String degree;
  int nbFollowers;
  int nbFollowings;
  int nbPosts;
  bool followed;


  School get university => school.university;


  User({id,
    this.followed,
    this.isActive,
    this.avatar,
    this.school,
    this.classYear,
    this.degree,
    this.firstname,
    this.lastname,
    this.description,
    this.major,
    this.minor,
    this.nbFollowers,
    this.nbFollowings,
    this.nbPosts}) : super(id: id);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
