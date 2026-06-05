// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      lastMessageTime: json['lastMessageTime'] == null
          ? null
          : DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantIds': instance.participantIds,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime?.toIso8601String(),
      'unreadCount': instance.unreadCount,
    };

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
    };
