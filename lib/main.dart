import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // User will generate this
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'presentation/router/app_router.dart';
import 'presentation/theme/app_theme.dart';
import 'data/providers/locale_provider.dart';
import 'data/providers/theme_provider.dart';

Future<void> _connectToFirebaseEmulators() async {
  final host = defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : 'localhost';

  try {
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    debugPrint('🔌 Connected to Firebase Emulators');
  } catch (e) {
    debugPrint('⚠️ Failed to connect to emulators: $e');
  }
}

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // LAW 2: Anti-Crash Infrastructure
      // Init Sequence: WidgetsBinding -> Firebase -> Localization

      bool firebaseInitialized = false;
      bool isDemoMode = false;
      try {
        await Firebase.initializeApp();
        firebaseInitialized = true;
      } catch (e) {
        debugPrint(
          "\n\n🛑🛑🛑 ВНИМАНИЕ: ОТСУТСТВУЕТ google-services.json! 🛑🛑🛑\n"
          "Приложение запущено в режиме EMULATOR FALLBACK (Demo).\n"
          "Для реальной работы добавьте файл в android/app/.\n\n",
        );
        // Fallback for Demo Mode (Works in Release too now)
        debugPrint("⚠️ Entering DEMO MODE (Offline/Emulator)");
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "demo-key",
            appId: "1:1234567890:android:321abc456def",
            messagingSenderId: "1234567890",
            projectId: "demo-popytka-ua",
          ),
        );
        firebaseInitialized = true;
        isDemoMode = true;
      }

      // EMULATOR CONNECTION
      if (kDebugMode && firebaseInitialized) {
        // Connect to emulators only in Demo Mode or if explicitly requested via compile-time flag
        const useEmulatorOverride = bool.fromEnvironment('USE_EMULATOR', defaultValue: false);
        if (isDemoMode || useEmulatorOverride) {
          await _connectToFirebaseEmulators();
        } else {
          debugPrint('☁️ Connected directly to Live Firebase Cloud Console (Debug Mode)');
        }
      }

      if (!firebaseInitialized) {
        runApp(const ConfigurationErrorScreen());
      } else {
        runApp(const ProviderScope(child: PopytkaApp()));
      }
    },
    (error, stack) {
      debugPrint("Global Error: $error");
      debugPrint(stack.toString());
    },
  );
}

class ConfigurationErrorScreen extends StatelessWidget {
  const ConfigurationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Configuration Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'google-services.json is missing.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  'Please add "google-services.json" to "android/app/" and rebuild.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PopytkaApp extends ConsumerWidget {
  const PopytkaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'Popytka UA',
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk'), // Default
        Locale('en'),
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
