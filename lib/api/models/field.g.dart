// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) {
  return Field(
      id: json['id'] == null ? null : AbstractModel.parseId(json['id']),
      name: json['name'] as String);
}

Map<String, dynamic> _$FieldToJson(Field instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
