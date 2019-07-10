// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hashtag _$HashtagFromJson(Map<String, dynamic> json) {
  return Hashtag(
      id: json['id'] == null ? null : AbstractModel.parseId(json['id']),
      name: json['name'] as String,
      nbFollowers: json['nbFollowers'] as int ?? 0,
      followed: json['followed'] as bool ?? false,
      picture: json['picture'] == null
          ? null
          : TwicFile.fromJson(json['picture'] as Map<String, dynamic>));
}

Map<String, dynamic> _$HashtagToJson(Hashtag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nbFollowers': instance.nbFollowers,
      'followed': instance.followed,
      'picture': instance.picture?.toJson()
    };
