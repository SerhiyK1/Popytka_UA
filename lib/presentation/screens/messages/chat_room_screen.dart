import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/data/repositories/chat_repository.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/domain/models/chat_model.dart';

// Part of Phase 7: Messaging
class ChatRoomScreen extends ConsumerStatefulWidget {
  final ChatModel chat;
  const ChatRoomScreen({super.key, required this.chat});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    ref
        .read(chatRepositoryProvider)
        .sendMessage(widget.chat.id, user.uid, text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(authRepositoryProvider).currentUser;
    final messagesStream = ref
        .watch(chatRepositoryProvider)
        .getMessages(widget.chat.id);

    return Scaffold(
      appBar: AppBar(title: Text("Chat"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data ?? [];

                return ListView.builder(
                  reverse: true, // Chat starts from bottom
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == user?.uid;
                    return _MessageBubble(message: msg, isMe: isMe);
                  },
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.cardSurface,
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: t.type_message,
                      hintStyle: const TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.black26,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primary
              : AppColors.secondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.text, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 2),
            Text(
              DateFormat('HH:mm').format(message.createdAt),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
