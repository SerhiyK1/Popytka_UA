import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  CollectionReference<ChatModel> get _chatsRef => _firestore
      .collection('chats')
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ChatModel.fromJson(snapshot.data()!..['id'] = snapshot.id),
        toFirestore: (chat, _) => chat.toJson()..remove('id'),
      );

  // 1. Get Chats for User
  Stream<List<ChatModel>> getMyChats(String userId) {
    return _chatsRef
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // 2. Get Messages for Chat
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _chatsRef
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              MessageModel.fromJson(snapshot.data()!..['id'] = snapshot.id),
          toFirestore: (msg, _) => msg.toJson()..remove('id'),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // 3. Send Message
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final messageRef = _chatsRef.doc(chatId).collection('messages').doc();
    final message = MessageModel(
      id: messageRef.id,
      senderId: senderId,
      text: text,
      createdAt: DateTime.now(),
      isRead: false,
    );

    // Batch to update Last Message in Chat Doc AND add Message to Subcollection
    final batch = _firestore.batch();
    batch.set(messageRef, message.toJson());
    batch.update(_chatsRef.doc(chatId), {
      'lastMessage': message.toJson(),
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // 4. Create or Get Chat (Idempotent)
  Future<String> createChat(String currentUserId, String otherUserId) async {
    // Check if chat exists (naive approach: query by both participants)
    // Firestore doesn't support logical AND for array-contains well directly for this case easily without composite indexes or specific structure.
    // OPTIMIZATION: We will fetch all chats for currentUser and filter in memory for MVP (assuming low volume).
    // Production view: Use a deterministic ID like "min(uid1, uid2)_max(uid1, uid2)" to avoid querying.

    final sortedIds = [currentUserId, otherUserId]..sort();
    final deterministicId = "${sortedIds[0]}_${sortedIds[1]}";

    final docRef = _chatsRef.doc(deterministicId);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      final chat = ChatModel(
        id: deterministicId,
        participantIds: sortedIds,
        lastMessageTime: DateTime.now(),
      );
      await docRef.set(chat);
    }

    return deterministicId;
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(FirebaseFirestore.instance);
}
