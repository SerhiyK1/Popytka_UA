import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
abstract class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required List<String> participantIds, // [userA, userB]
    MessageModel? lastMessage,
    DateTime? lastMessageTime,
    @Default(0) int unreadCount,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String senderId,
    required String text,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
