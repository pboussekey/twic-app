import 'package:twic_app/api/models/school.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:twic_app/api/models/field.dart';

import 'abstract_model.dart';

class User extends AbstractModel {
  int id;
  String firstname;
  String lastname;
  TwicFile avatar;
  School _school;
  Field major;
  Field minor;
  bool isActive;
  int classYear;
  String degree;
  int nbFollowers;
  int nbFollowings;
  int nbPosts;
  bool followed;

  School get university => _school.university ?? _school;

  School get school => null != _school.university ? _school : null;

  User.fromJson(Map<String, dynamic> data) {
    id = data['id'] is int ? data['id'] : int.parse(data['id']);
    firstname = data['firstname'];
    lastname = data['lastname'];
    isActive = data['isActive'] ?? false;
    classYear = data['classYear'];
    degree = data['degree'];
    nbFollowers = data['nbFollowers'] ?? 0;
    nbFollowings = data['nbFollowings'] ?? 0;
    nbPosts = data['nbPosts'] ?? 0;
    followed = data['followed'] ?? false;
    if (null != data['avatar']) {
      avatar = TwicFile.fromJson(data['avatar']);
    }
    if (null != data['school']) {
      _school = School.fromJson(data['school']);
    }
    if (null != data['major']) {
      major = Field.fromJson(data['major']);
    }
    if (null != data['minor']) {
      minor = Field.fromJson(data['minor']);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'isActive': isActive,
        'nbFollowers': nbFollowers,
        'followed': followed,
        'classYear': classYear,
        'degree': degree,
        'avatar': null != avatar ? avatar.toJson() : null,
        'school': null != _school ? _school.toJson() : null,
        'major': null != major ? major.toJson() : null,
        'minor': null != minor ? minor.toJson() : null
      };
}
