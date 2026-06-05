import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading/auth check delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // LOGO CONSTRUCTION
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Popy",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "tka",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const Text(
                  "_",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const Text(
                  "UA",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow Icon mimicking the logo
                const Icon(
                  Icons.north_east,
                  color: AppColors.primary,
                  size: 40,
                ),
              ],
            ),

            const Spacer(),

            // LOADER
            const CircularProgressIndicator(
              color: AppColors.primary,
            ), // Yellow loader
            const SizedBox(height: 20),
            Text(t.loading, style: const TextStyle(color: Colors.white70)),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
