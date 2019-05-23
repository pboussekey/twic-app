// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
      id: json['id'] == null ? null : AbstractModel.parseId(json['id']),
      text: json['text'] as String,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String))
    ..attachment = json['attachment'] == null
        ? null
        : TwicFile.fromJson(json['attachment'] as Map<String, dynamic>)
    ..conversation_id = json['conversation_id'] == null
        ? null
        : AbstractModel.parseId(json['conversation_id']);
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'user': instance.user?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'attachment': instance.attachment?.toJson(),
      'conversation_id': instance.conversation_id
    };
