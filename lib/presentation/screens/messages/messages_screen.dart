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
import 'package:popytka_ua/data/providers/user_provider.dart';

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
              final otherId = chat.participantIds.firstWhere(
                (id) => id != user.uid,
                orElse: () => "Unknown",
              );

              return Consumer(
                builder: (context, ref, child) {
                  final otherUserAsync = ref.watch(userByIdProvider(otherId));
                  final onSurface = Theme.of(context).colorScheme.onSurface;

                  return otherUserAsync.when(
                    data: (otherUser) {
                      final name = otherUser?.name ?? "Користувач";
                      final photoUrl = otherUser?.photoUrl;

                      return SurfaceCard(
                        onTap: () {
                          context.push('/chat_room', extra: chat);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                            child: photoUrl == null
                                ? const Icon(Icons.person, color: AppColors.secondary)
                                : null,
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: onSurface,
                            ),
                          ),
                          subtitle: Text(
                            lastMsg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: onSurface.withValues(alpha: 0.6)),
                          ),
                          trailing: chat.lastMessageTime != null
                              ? Text(
                                  DateFormat('HH:mm').format(chat.lastMessageTime!),
                                  style: TextStyle(
                                    color: onSurface.withValues(alpha: 0.4),
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                    loading: () => SurfaceCard(
                      child: const ListTile(
                        title: SizedBox(
                          height: 16,
                          child: Center(
                            child: LinearProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    error: (e, _) => SurfaceCard(
                      child: ListTile(
                        title: Text(
                          "Користувач: ${otherId.substring(0, 6)}...",
                          style: TextStyle(color: onSurface),
                        ),
                        subtitle: Text(
                          lastMsg,
                          style: TextStyle(color: onSurface.withValues(alpha: 0.6)),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
