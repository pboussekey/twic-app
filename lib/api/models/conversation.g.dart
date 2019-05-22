// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return Conversation(
      id: json['id'] == null ? null : AbstractModel.parseId(json['id']),
      name: json['name'] as String,
      last: json['last'] as String,
      lastDate: json['lastDate'] == null
          ? null
          : DateTime.parse(json['lastDate'] as String),
      users: (json['users'] as List)
          ?.map((e) =>
              e == null ? null : User.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..picture = json['picture'] == null
        ? null
        : TwicFile.fromJson(json['picture'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'last': instance.last,
      'users': instance.users?.map((e) => e?.toJson())?.toList(),
      'lastDate': instance.lastDate?.toIso8601String(),
      'picture': instance.picture?.toJson()
    };
