// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twic_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwicFile _$TwicFileFromJson(Map<String, dynamic> json) {
  return TwicFile(
      id: json['id'] == null ? null : AbstractModel.parseId(json['id']),
      name: json['name'] as String,
      bucketname: json['bucketname'] as String,
      token: json['token'] as String,
      type: json['type'] as String)
    ..preview = json['preview'] == null
        ? null
        : TwicFile.fromJson(json['preview'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TwicFileToJson(TwicFile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bucketname': instance.bucketname,
      'type': instance.type,
      'token': instance.token,
      'preview': instance.preview?.toJson()
    };
