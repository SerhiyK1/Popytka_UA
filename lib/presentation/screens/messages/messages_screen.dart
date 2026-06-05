import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/data/repositories/chat_repository.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';
import 'package:popytka_ua/presentation/widgets/surface_card.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/domain/models/chat_model.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(authRepositoryProvider).currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final chatsAsync = ref.watch(chatRepositoryProvider).getMyChats(user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.chat_title),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: chatsAsync,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data ?? [];

          if (chats.isEmpty) {
            return Center(
              child: Text(
                t.no_chats,
                style: const TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final lastMsg = chat.lastMessage?.text ?? "Draft";
              // Identify "Other user" (naive: pick first not me)
              // In real app we fetch User Profile. For MVP we show "User ID" or generic.
              final otherId = chat.participantIds.firstWhere(
                (id) => id != user.uid,
                orElse: () => "Unknown",
              );

              return SurfaceCard(
                onTap: () {
                  context.push('/chat_room', extra: chat);
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                  title: Text(
                    "User: ${otherId.substring(0, 6)}...",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    lastMsg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: chat.lastMessageTime != null
                      ? Text(
                          DateFormat('HH:mm').format(chat.lastMessageTime!),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
