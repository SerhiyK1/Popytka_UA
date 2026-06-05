import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/surface_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_title), // Popytka_UA
        leading: IconButton(
          onPressed: () => context.go('/profile'),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // USER MGMT CARD
            _AdminSummaryCard(
              icon: Icons.person,
              iconColor: AppColors.secondary,
              title: t.admin_users_title,
              stats: ["120 ${t.stat_active_users}", "15 ${t.stat_new_users}"],
              actionLabel: t.btn_manage,
              onAction: () => context.push('/admin/users'),
            ),
            const SizedBox(height: 16),

            // RIDE MGMT CARD
            _AdminSummaryCard(
              icon: Icons.directions_car,
              iconColor: AppColors.primary,
              title: t.admin_rides_title,
              stats: [
                "34 ${t.stat_current_rides}",
                "5 ${t.stat_completed_rides}",
              ],
              actionLabel: t.btn_view,
              onAction: () => context.push('/admin/rides'),
            ),
            const SizedBox(height: 16),

            // REPORTS CARD
            _AdminSummaryCard(
              icon: Icons.bar_chart,
              iconColor: Colors.blueAccent, // Variant
              title: t.admin_reports_title,
              stats: [t.stat_report_avail],
              actionLabel: t.btn_open,
              onAction: () {},
            ),
            const SizedBox(height: 16),

            // NOTIFICATIONS CARD
            _AdminSummaryCard(
              icon: Icons.notifications,
              iconColor: AppColors.primary,
              title: t.admin_notifications_title,
              stats: ["5 ${t.stat_unreviewed}"],
              actionLabel: t.btn_go,
              onAction: () {},
            ),
            const SizedBox(height: 16),

            // SETTINGS CARD
            _AdminSummaryCard(
              icon: Icons.settings,
              iconColor: AppColors.secondary,
              title: t.admin_settings_title,
              stats: ["${t.version} 2.1.0"],
              actionLabel: t.btn_configure,
              onAction: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<String> stats;
  final String actionLabel;
  final VoidCallback onAction;

  const _AdminSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.stats,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2), // Slight tint
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...stats.map(
            (s) => Text(s, style: const TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.black,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}
