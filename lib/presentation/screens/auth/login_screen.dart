import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';
import 'package:popytka_ua/data/repositories/user_repository.dart';
import 'package:popytka_ua/domain/models/user_model.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      final result = await authRepo.signInWithGoogle();

      if (result == null && mounted) {
        // User cancelled - show nothing or a subtle message
        setState(() => _isLoading = false);
        return;
      }

      // Create user profile if it doesn't exist
      if (result != null && result.user != null) {
        final firebaseUser = result.user!;
        final existingUser = await userRepo.getUser(firebaseUser.uid);

        if (existingUser == null) {
          // Create new user profile
          final newUser = UserModel(
            id: firebaseUser.uid,
            phone: firebaseUser.phoneNumber ?? '',
            name: firebaseUser.displayName ?? 'User',
            photoUrl: firebaseUser.photoURL,
            role: 'rider', // Default role
          );

          await userRepo.createUser(newUser);
        }
      }

      // Router will handle navigation
    } catch (e) {
      debugPrint("Google Sign-In failed: $e");
      final errorStr = e.toString();
      
      if (errorStr.contains('10') || errorStr.contains('sign_in_failed') || errorStr.contains('ApiException')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Помилка сертифікату Google Sign-In. Автоматичний вхід у демо-режимі..."),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
        await _signInDemoMode();
        return;
      }

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Future<void> _signInDemoMode() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      await authRepo.signInAnonymously();
      final firebaseUser = authRepo.currentUser;

      if (firebaseUser != null) {
        final existingUser = await userRepo.getUser(firebaseUser.uid);

        if (existingUser == null) {
          await userRepo.createUser(
            UserModel(
              id: firebaseUser.uid,
              phone: '',
              name: 'Demo User',
              role: 'rider',
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. Background Map
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(49.0, 31.0),
              initialZoom: 6.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
            ],
          ),

          // 2. Overlay
          Container(color: Colors.black54),

          // 3. Auth Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: GlassContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_person,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.login_title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.login_subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),

                    // Google Sign-In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _signInWithGoogle,
                        icon: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.png',
                                height: 20,
                                width: 20,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.g_mobiledata, size: 20),
                              ),
                        label: Text(
                          _isLoading ? '...' : t.btn_sign_in_google,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
