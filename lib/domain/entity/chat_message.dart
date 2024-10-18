import 'package:brainwavesocialapp/data/data.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChatMessage extends MessageDataModel {
  ChatMessage({
    required super.uid,
    required super.senderId,
    required super.content,
    required super.timestamp,
    required super.messageType,
    required super.readBy,
  });

  toDataModel() {
    return MessageDataModel(
      uid: super.uid,
      senderId: super.senderId,
      content: super.content,
      messageType: super.messageType,
      timestamp: super.timestamp,
      readBy: super.readBy,
    );
  }

  factory ChatMessage.fromDataModel(MessageDataModel dataModel) {
    return ChatMessage(
      readBy: dataModel.readBy,
      uid: dataModel.uid,
      senderId: dataModel.senderId,
      messageType: dataModel.messageType,
      content: dataModel.content,
      timestamp: dataModel.timestamp,
    );
  }
}
