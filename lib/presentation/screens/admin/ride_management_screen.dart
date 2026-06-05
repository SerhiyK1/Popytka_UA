import 'package:flutter/material.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/surface_card.dart';
import 'package:go_router/go_router.dart';

class RideManagementScreen extends StatelessWidget {
  const RideManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.admin_rides_title),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: t.tab_active),
              Tab(text: t.tab_planned),
              Tab(text: t.tab_completed),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RideList(status: t.status_in_transit, color: Colors.blueAccent),
            _RideList(status: t.status_planned, color: Colors.orangeAccent),
            _RideList(status: t.status_completed, color: Colors.greenAccent),
          ],
        ),
      ),
    );
  }
}

class _RideList extends StatelessWidget {
  final String status;
  final Color color;

  const _RideList({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _RideCard(
          id: "#12345",
          from: "Київ",
          to: "Львів",
          status: status,
          statusColor: color,
          t: t,
        ),
        _RideCard(
          id: "#12346",
          from: "Одеса",
          to: "Харків",
          status: status,
          statusColor: color,
          t: t,
        ),
      ],
    );
  }
}

class _RideCard extends StatelessWidget {
  final String id;
  final String from;
  final String to;
  final String status;
  final Color statusColor;
  final AppLocalizations t;

  const _RideCard({
    required this.id,
    required this.from,
    required this.to,
    required this.status,
    required this.statusColor,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${t.app_title.split(' ')[0]} $id",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          _row("Водій", "Іван Петренко"), // Hardcoded for mockup consistency
          _row("Маршрут", "$from - $to"),
          _row("Тривалість", "1 год 30 хв"),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(
                    '/placeholder?title=${Uri.encodeComponent(t.btn_details)}',
                  ),
                  child: Text(t.btn_details),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(
                    '/placeholder?title=${Uri.encodeComponent(t.status_completed == status ? t.btn_archive : t.btn_issue)}',
                  ),
                  child: Text(
                    t.status_completed == status ? t.btn_archive : t.btn_issue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.white54)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
