import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/convertors.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatDataModel {
  ChatDataModel(
      {required this.chatId,
      required this.participants,
      required this.lastMessage,
      required this.lastMessageTimeStamp,
      required this.type,
      required this.unreadCount});

  @JsonKey(includeToJson: false)
  final List<String> participants;
  final String chatId;
  final String lastMessage;
  final String type;
  final Map<String, dynamic> unreadCount;

  @JsonKey(
    fromJson: TimestampConverter.fromJson,
    toJson: TimestampConverter.toJson,
  )
  final DateTime? lastMessageTimeStamp;

  factory ChatDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    _,
  ) {
    final data = snapshot.data()!;

    return ChatDataModel.fromJson({
      ...data,
      'uid': snapshot.id,
    });
  }

  factory ChatDataModel.fromJson(Map<String, dynamic> json) =>
      _$ChatDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDataModelToJson(this);
}
