// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmMessage _$FcmMessageFromJson(Map<String, dynamic> json) {
  return FcmMessage(
      type: json['type'] as String,
      data: json['data'] == null ? null : FcmMessage.parseData(json['data']));
}

Map<String, dynamic> _$FcmMessageToJson(FcmMessage instance) =>
    <String, dynamic>{'type': instance.type, 'data': instance.data};
