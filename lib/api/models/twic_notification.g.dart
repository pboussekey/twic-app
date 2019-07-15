// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twic_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwicNotification _$TwicNotificationFromJson(Map<String, dynamic> json) {
  return TwicNotification(
      type: json['type'] as String, text: json['text'] as String)
    ..id = json['id'] == null ? null : AbstractModel.parseId(json['id'])
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..count = json['count'] as int
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..files = (json['files'] as List)
        ?.map((e) =>
            e == null ? null : TwicFile.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TwicNotificationToJson(TwicNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'text': instance.text,
      'createdAt': instance.createdAt?.toIso8601String(),
      'count': instance.count,
      'user': instance.user?.toJson(),
      'files': instance.files?.map((e) => e?.toJson())?.toList()
    };
