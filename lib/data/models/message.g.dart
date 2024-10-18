// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDataModel _$MessageDataModelFromJson(Map<String, dynamic> json) =>
    MessageDataModel(
      uid: json['uid'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: TimestampConverter.fromJson(json['timestamp'] as Timestamp?),
      messageType: json['messageType'] as String,
      readBy:
          (json['readBy'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MessageDataModelToJson(MessageDataModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'content': instance.content,
      'messageType': instance.messageType,
      'readBy': instance.readBy,
      'timestamp': TimestampConverter.toJson(instance.timestamp),
    };
