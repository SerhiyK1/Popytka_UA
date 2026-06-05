import 'package:flutter/material.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/surface_card.dart';
import 'package:go_router/go_router.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.admin_users_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => context.push(
              '/placeholder?title=${Uri.encodeComponent("Фільтри")}',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: t.search_placeholder,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _UserCard(
                  name: "Іван Петренко",
                  role: t.driver_label,
                  isActive: true,
                  t: t,
                ),
                _UserCard(
                  name: "Марія Шевченко",
                  role: t.passenger_label,
                  isActive: true,
                  t: t,
                ),
                _UserCard(
                  name: "Марія Шевченко",
                  role: t.passenger_label,
                  isActive: false, // Blocked mock
                  t: t,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String name;
  final String role;
  final bool isActive;
  final AppLocalizations t;

  const _UserCard({
    required this.name,
    required this.role,
    required this.isActive,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isActive ? Colors.greenAccent : Colors.redAccent;
    final statusText = isActive ? t.status_active : t.status_blocked;

    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Text(name[0])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${t.role_label}: $role",
                  style: const TextStyle(color: Colors.white70),
                ),
                Row(
                  children: [
                    Text(
                      "${t.status_label}: ",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(statusText, style: TextStyle(color: statusColor)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SmallBtn(
                icon: Icons.visibility,
                label: t.btn_view,
                onTap: () => context.push(
                  '/placeholder?title=${Uri.encodeComponent(t.btn_view)}',
                ),
              ),
              _SmallBtn(
                icon: Icons.edit,
                label: t.btn_edit,
                onTap: () => context.push(
                  '/placeholder?title=${Uri.encodeComponent(t.btn_edit)}',
                ),
              ),
              _SmallBtn(
                icon: isActive ? Icons.lock : Icons.lock_open,
                label: isActive ? t.btn_block : t.btn_unblock,
                onTap: () => context.push(
                  '/placeholder?title=${Uri.encodeComponent(isActive ? t.btn_block : t.btn_unblock)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmallBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
