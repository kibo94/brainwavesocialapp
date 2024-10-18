import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../utils/convertors.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageDataModel {
  MessageDataModel({
    required this.uid,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.messageType,
    required this.readBy,
  });

  @JsonKey(includeToJson: false)
  final String uid;
  final String senderId;
  final String content;
  final String messageType;
  final List<String> readBy;

  @JsonKey(
    fromJson: TimestampConverter.fromJson,
    toJson: TimestampConverter.toJson,
  )
  final DateTime timestamp;

  factory MessageDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    _,
  ) {
    final data = snapshot.data()!;
    return MessageDataModel.fromJson({
      ...data,
      'uid': snapshot.id,
    });
  }

  factory MessageDataModel.fromJson(Map<String, dynamic> json) =>
      _$MessageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDataModelToJson(this);
}
