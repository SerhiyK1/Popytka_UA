import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository.dart';
import '../widgets/app_nav_bar.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/publish/publish_ride_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/user_management_screen.dart';
import '../screens/admin/ride_management_screen.dart';
import '../screens/search/search_results_screen.dart';
import '../screens/ride/ride_details_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/messages/chat_room_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/wallet_screen.dart';
import '../screens/rides/my_rides_screen.dart';
import '../../domain/models/ride_model.dart';
import '../../domain/models/chat_model.dart';
import '../screens/rating/rate_ride_screen.dart';
import '../../domain/models/user_model.dart';
import '../screens/placeholder_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final authRepo = ref.watch(authRepositoryProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: _StreamToLegacyListenable(authRepo.authStateChanges),

    redirect: (context, state) {
      final isLoggedIn = authRepo.currentUser != null;
      final isLoggingIn = state.uri.toString() == '/login';
      final isSplash = state.uri.toString() == '/splash';

      if (!isLoggedIn && !isLoggingIn && !isSplash) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/placeholder',
        builder: (context, state) => PlaceholderScreen(
          title: state.uri.queryParameters['title'] ?? 'В розробці',
        ),
      ),

      // Search & Booking
      GoRoute(
        path: '/search_results',
        builder: (context, state) {
          final query = state.uri.queryParameters;
          return SearchResultsScreen(
            fromCity: query['from'] ?? '',
            toCity: query['to'] ?? '',
            selectedDate: query['date'],
            selectedTime: query['time'],
            requiredSeats: int.tryParse(query['seats'] ?? '1') ?? 1,
          );
        },
      ),
      GoRoute(
        path: '/ride_details',
        builder: (context, state) {
          final ride = state.extra as RideModel;
          return RideDetailsScreen(ride: ride);
        },
      ),

      // Chat
      GoRoute(
        path: '/chat_room',
        builder: (context, state) {
          final chat = state.extra as ChatModel;
          return ChatRoomScreen(chat: chat);
        },
      ),

      // Profile Edit
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) {
          final user = state.extra as UserModel;
          return EditProfileScreen(user: user);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),

      // Edit Ride
      GoRoute(
        path: '/edit_ride',
        builder: (context, state) {
          final ride = state.extra as RideModel;
          return PublishRideScreen(existingRide: ride);
        },
      ),

      // My Rides
      GoRoute(
        path: '/my_rides',
        builder: (context, state) => const MyRidesScreen(),
      ),

      // Rating
      GoRoute(
        path: '/rate_ride',
        builder: (context, state) {
          final map = state.extra as Map<String, String>;
          final rideId = map['rideId']!;
          final ratedId = map['ratedId']!;
          return RateRideScreen(rideId: rideId, ratedId: ratedId);
        },
      ),

      // Admin
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'users',
            builder: (context, state) => const UserManagementScreen(),
          ),
          GoRoute(
            path: 'rides',
            builder: (context, state) => const RideManagementScreen(),
          ),
        ],
      ),

      // Main Tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // HOME TAB
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // PUBLISH TAB
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/publish',
                builder: (context, state) {
                  final ride = state.extra as RideModel?;
                  return PublishRideScreen(existingRide: ride);
                },
              ),
            ],
          ),
          // MESSAGES TAB
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/messages',
                builder: (context, state) => const MessagesScreen(),
              ),
            ],
          ),
          // PROFILE TAB
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _StreamToLegacyListenable extends ChangeNotifier {
  final Stream<dynamic> _stream;

  _StreamToLegacyListenable(this._stream) {
    _stream.listen((_) => notifyListeners());
  }
}
