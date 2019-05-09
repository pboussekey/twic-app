// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
      id: json['id'] == null ? null : AbstractModel.parseId(json['id']),
      content: json['content'] as String,
      privacy: json['privacy'] as String,
      files: (json['files'] as List)
          ?.map((e) =>
              e == null ? null : TwicFile.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      nbLikes: json['nbLikes'] as int,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      isLiked: json['isLiked'] == null
          ? null
          : AbstractModel.parseBool(json['isLiked']),
      nbComments: json['nbComments'] as int);
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'privacy': instance.privacy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'nbComments': instance.nbComments,
      'nbLikes': instance.nbLikes,
      'isLiked': instance.isLiked,
      'user': instance.user?.toJson(),
      'files': instance.files?.map((e) => e?.toJson())?.toList()
    };