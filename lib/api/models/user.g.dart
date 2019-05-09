// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['id'] == null ? null : AbstractModel.parseId(json['id']),
      followed: json['followed'] == null
          ? null
          : AbstractModel.parseBool(json['followed']),
      isActive: json['isActive'] as bool,
      avatar: json['avatar'] == null
          ? null
          : TwicFile.fromJson(json['avatar'] as Map<String, dynamic>),
      s: json['s'] == null
          ? null
          : School.fromJson(json['s'] as Map<String, dynamic>),
      classYear: json['classYear'] as int,
      degree: json['degree'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      major: json['major'] == null
          ? null
          : Field.fromJson(json['major'] as Map<String, dynamic>),
      minor: json['minor'] == null
          ? null
          : Field.fromJson(json['minor'] as Map<String, dynamic>),
      nbFollowers: json['nbFollowers'] as int,
      nbFollowings: json['nbFollowings'] as int,
      nbPosts: json['nbPosts'] as int)
    ..school = json['school'] == null
        ? null
        : School.fromJson(json['school'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'avatar': instance.avatar?.toJson(),
      's': instance.s?.toJson(),
      'major': instance.major?.toJson(),
      'minor': instance.minor?.toJson(),
      'isActive': instance.isActive,
      'classYear': instance.classYear,
      'degree': instance.degree,
      'nbFollowers': instance.nbFollowers,
      'nbFollowings': instance.nbFollowings,
      'nbPosts': instance.nbPosts,
      'followed': instance.followed,
      'school': instance.school?.toJson()
    };
