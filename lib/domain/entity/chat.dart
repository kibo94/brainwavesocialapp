import 'package:brainwavesocialapp/data/data.dart';
import 'package:flutter/foundation.dart';

@immutable
class Chat extends ChatDataModel {
  Chat(
      {required super.chatId,
      required super.participants,
      required super.lastMessage,
      required super.lastMessageTimeStamp,
      required super.type,
      required super.unreadCount});

  toDataModel() {
    return ChatDataModel(
      participants: super.participants,
      chatId: super.chatId,
      lastMessage: super.lastMessage,
      lastMessageTimeStamp: super.lastMessageTimeStamp,
      type: super.type,
      unreadCount: super.unreadCount,
    );
  }

  factory Chat.fromDataModel(ChatDataModel dataModel) {
    return Chat(
      participants: dataModel.participants,
      chatId: dataModel.chatId,
      lastMessage: dataModel.lastMessage,
      lastMessageTimeStamp: dataModel.lastMessageTimeStamp,
      type: dataModel.type,
      unreadCount: dataModel.unreadCount,
    );
  }
}
