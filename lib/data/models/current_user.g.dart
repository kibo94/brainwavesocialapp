// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserDataModel _$CurrentUserDataModelFromJson(
        Map<String, dynamic> json) =>
    CurrentUserDataModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$CurrentUserDataModelToJson(
        CurrentUserDataModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
    };
