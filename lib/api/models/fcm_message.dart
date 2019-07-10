import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'fcm_message.g.dart';

@JsonSerializable()
class FcmMessage {
  static const Message = "Message";
  static const Notification = "Notification";

  static Map<String, dynamic> parseData(data) => Map<String, dynamic>.from(data);
  String type;
  @JsonKey(fromJson: parseData)
  Map<String, dynamic> data;

  FcmMessage({this.type, this.data});

  factory FcmMessage.fromJson(Map<String, dynamic> json) =>
      _$FcmMessageFromJson(json);

  Map<String, dynamic> toJson() => _$FcmMessageToJson(this);
}
