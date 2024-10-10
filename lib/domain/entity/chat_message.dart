import 'package:brainwavesocialapp/data/data.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChatMessage extends MessageDataModel {
  ChatMessage(
      {required super.uid,
      required super.ownerId,
      required super.content,
      required super.timestamp,
      required super.userEmail});

  toDataModel() {
    return MessageDataModel(
        uid: super.uid,
        ownerId: super.ownerId,
        content: super.content,
        timestamp: super.timestamp,
        userEmail: super.userEmail);
  }

  factory ChatMessage.fromDataModel(MessageDataModel dataModel) {
    return ChatMessage(
        uid: dataModel.uid,
        ownerId: dataModel.ownerId,
        content: dataModel.content,
        timestamp: dataModel.timestamp,
        userEmail: dataModel.userEmail);
  }
}
