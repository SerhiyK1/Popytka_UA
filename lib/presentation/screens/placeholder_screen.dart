import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Цей розділ в розробці',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ми активно працюємо над цією функцією.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Повернутися назад'),
            ),
          ],
        ),
      ),
    );
  }
}
