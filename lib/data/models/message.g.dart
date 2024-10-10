// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDataModel _$MessageDataModelFromJson(Map<String, dynamic> json) =>
    MessageDataModel(
      uid: json['uid'] as String,
      ownerId: json['ownerId'] as String,
      content: json['content'] as String,
      timestamp: TimestampConverter.fromJson(json['timestamp'] as Timestamp?),
      userEmail: json['userEmail'] as String,
    );

Map<String, dynamic> _$MessageDataModelToJson(MessageDataModel instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'content': instance.content,
      'userEmail': instance.userEmail,
      'timestamp': TimestampConverter.toJson(instance.timestamp),
    };
