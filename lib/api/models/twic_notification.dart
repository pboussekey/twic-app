import 'package:json_annotation/json_annotation.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:twic_app/api/models/user.dart';
import 'abstract_model.dart';

import 'dart:convert';

part 'twic_notification.g.dart';

@JsonSerializable()
class TwicNotification extends AbstractModel {
  String type;
  String text;
  DateTime createdAt;
  int count;
  User user;
  List<TwicFile> files;

  String get formattedText {
    return text
        .replaceAll('{user}', '${user.firstname} ${user.lastname}')
        .replaceAll(' {count}', count > 1 ? ' and $count others' : '');
  }

  TwicNotification({this.type, this.text});

  factory TwicNotification.fromJson(Map<String, dynamic> json) =>
      _$TwicNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$TwicNotificationToJson(this);
}
