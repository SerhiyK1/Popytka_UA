import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:popytka_ua/data/repositories/ride_repository.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/domain/models/ride_model.dart';
import 'package:go_router/go_router.dart';

class MyRidesScreen extends ConsumerStatefulWidget {
  const MyRidesScreen({super.key});

  @override
  ConsumerState<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends ConsumerState<MyRidesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(t.my_rides),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
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
      body: currentUser.when(
        data: (user) => user == null
            ? Center(child: Text(t.please_login))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildRidesList('active', user.id),
                  _buildRidesList('pending', user.id),
                  _buildRidesList('completed', user.id),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('${t.error_prefix}$error')),
      ),
    );
  }

  Widget _buildRidesList(String status, String userId) {
    final t = AppLocalizations.of(context)!;
    return StreamBuilder<List<RideModel>>(
      stream: ref.read(rideRepositoryProvider).getUserRides(userId, status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  '${t.error_prefix}${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final rides = snapshot.data ?? [];

        if (rides.isEmpty) {
          return _buildEmptyState(status);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rides.length,
          itemBuilder: (context, index) {
            final ride = rides[index];
            return _buildRideCard(ride);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    final t = AppLocalizations.of(context)!;
    String message;
    IconData icon;

    switch (status) {
      case 'active':
        message = t.no_active_rides;
        icon = Icons.directions_car;
        break;
      case 'pending':
        message = t.no_planned_rides;
        icon = Icons.schedule;
        break;
      case 'completed':
        message = t.no_completed_rides;
        icon = Icons.check_circle_outline;
        break;
      default:
        message = t.no_rides_found;
        icon = Icons.directions_car_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            status == 'pending' ? t.create_first_ride : t.rides_appear_here,
            style: const TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard(RideModel ride) {
    final t = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${ride.fromLocation.city} → ${ride.toLocation.city}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusChip(ride.status),
            ],
          ),

          const SizedBox(height: 12),

          // Details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(ride.departureTime),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${ride.seatsAvailable} ${t.seats_available}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Text(
                '₴${ride.pricePerSeat.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.push('/ride_details', extra: ride);
                },
                child: Text(t.btn_details),
              ),
              if (ride.status == 'completed') ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.push(
                      '/rate_ride',
                      extra: {'rideId': ride.id, 'ratedId': ride.riderId},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(t.rate_trip),
                ),
              ],
              if (ride.status == 'pending') ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Edit ride functionality
                    _showEditRideDialog(ride);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(t.btn_edit),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _confirmCancelRide(ride),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  child: Text(t.cancel),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _confirmCancelRide(RideModel ride) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          t.cancel_ride_title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          t.cancel_ride_warning,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.no),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (!context.mounted) return;
              try {
                await ref.read(rideRepositoryProvider).cancelRide(ride.id);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.ride_cancelled_success)),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("${t.error_prefix}$e")));
              }
            },
            child: Text(
              t.yes_cancel,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final t = AppLocalizations.of(context)!;
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = Colors.green;
        text = t.tab_active;
        break;
      case 'pending':
        color = Colors.orange;
        text = t.tab_planned;
        break;
      case 'completed':
        color = Colors.blue;
        text = t.tab_completed;
        break;
      case 'cancelled':
        color = Colors.red;
        text = t.status_cancelled;
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEditRideDialog(RideModel ride) {
    context.push('/edit_ride', extra: ride);
  }
}
