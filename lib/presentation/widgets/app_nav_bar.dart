import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true, // Important for glass effect over map
      body: navigationShell,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // Floating Glass Nav Bar
        child: GlassContainer(
          borderRadius: 30, // Rounded pill shape
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.search,
                label: t.nav_search,
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _goBranch(0),
              ),
              _NavItem(
                icon: Icons.add_circle_outline, // Or specific car icon
                label: t.nav_publish,
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _goBranch(1),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: t.nav_messages,
                isSelected: navigationShell.currentIndex == 2,
                onTap: () => _goBranch(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: t.nav_profile,
                isSelected: navigationShell.currentIndex == 3,
                onTap: () => _goBranch(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.secondary : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}
