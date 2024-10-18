// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDataModel _$ChatDataModelFromJson(Map<String, dynamic> json) =>
    ChatDataModel(
      chatId: json['chatId'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageTimeStamp: TimestampConverter.fromJson(
          json['lastMessageTimeStamp'] as Timestamp?),
      type: json['type'] as String,
      unreadCount: json['unreadCount'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ChatDataModelToJson(ChatDataModel instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'lastMessage': instance.lastMessage,
      'type': instance.type,
      'unreadCount': instance.unreadCount,
      'lastMessageTimeStamp':
          TimestampConverter.toJson(instance.lastMessageTimeStamp),
    };
